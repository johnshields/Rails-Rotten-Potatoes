class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all
    @all_ratings = Movie.all_ratings
    sort_params = params[:sort]
    case sort_params
      when 'title'
        ordering, @title_header = {:title => :asc}, 'bg-warning hilite'
      when 'release_date'
        ordering, @release_date_header = {:release_date => :asc}, 'bg-warning hilite'
    end
    
    # check boxes
    if params[:ratings]
      # show rating if a check box is ticked
      @ratings_to_show = params[:ratings]
    else 
      # no check boxes ticked
      @ratings_to_show = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort] && params[:ratings]
      sort = params[:sort]
      @ratings_to_show = params[:ratings]
      redirect_to :sort => sort, :ratings => @ratings_to_show and return
    end
    @movies = Movie.where(rating: @ratings_to_show.keys).order(ordering)
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
