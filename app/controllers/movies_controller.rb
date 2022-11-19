class MoviesController < ApplicationController
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]

  def index
    @movies = Movie.send(movies_filter)
  end

  def show
    @movie = Movie.find(params[:id])
    @fans = @movie.fans
    @review = @movie.reviews.new
    @genres = @movie.genres.order(:name)
    @favourite = current_user.favourites.find_by(movie_id: @movie.id) if current_user
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie,  notice: 'Movie successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Movie successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    redirect_to movies_url, status: :see_other,
                            alert: 'Movie successfully deleted!'
  end

  private

  def movies_filter
    if params[:filter].in? %w[upcoming recent hits flops]
      params[:filter]
    else
      :released
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :description, :rating, :released_on, :total_gross, :director, :duration,
                                  :image_file_name, genre_ids: [])
  end
end
