class MoviesController < ApplicationController
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]
  before_action :set_movie, only: %i[show edit update destroy]

  def index
    @movies = Movie.send(movies_filter)
  end

  def show
    @fans = @movie.fans
    @review = @movie.reviews.new
    @genres = @movie.genres.order(:name)
    @favourite = current_user.favourites.find_by(movie_id: @movie.id) if current_user
  end

  def new
    @movie = Movie.new
  end

  def edit; end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie,  notice: 'Movie successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Movie successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
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
                                  :main_image, genre_ids: [])
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end
end
