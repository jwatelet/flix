class FavouritesController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def create
    @movie.favourites.create!(user: current_user)

    redirect_to @movie
  end

  def destroy
    @favourite = Favourite.find(params[:id])
    @favourite.destroy if @favourite.user == current_user

    redirect_to @movie
  end

  private

  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end
end
