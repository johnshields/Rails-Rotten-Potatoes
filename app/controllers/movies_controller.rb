class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @sort = params[:sort] || session[:sort]
    # sort the movies by rating
    if params[:ratings] || session[:ratings]
      params[:ratings].nil? ? @ratings_to_show = @all_ratings : @ratings_to_show = params[:ratings].keys
      @movies = Movie.where(rating: @ratings_to_show).order(@sort)
    else
      @ratings_to_show = Hash[@all_ratings]
    end
    # sort the movies by title & release date 
    if params[:sort] || session[:sort]
      @movies = Movie.all.order(@sort)
    end
  end # end index
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
