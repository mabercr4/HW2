class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
	  if params[:sort_by]
		  @sort = session[:sort_by] = params[:sort_by]
		elsif session[:sort_by]
		  @sort = session[:sort_by]
	  else
		  @sort = 'id'
	  end
	
	  if @sort == 'title'
	  	@title_class = 'hilite'
	  elsif @sort == 'release_date'
	  	@release_date_class = 'hilite'
	  end
	  
	  if params[:ratings]
	    @filtered_ratings = session[:ratings] = params[:ratings]
	  elsif session[:ratings]
	    @filtered_ratings = session[:ratings]
	  else
	    @filtered_ratings = @all_ratings
	  end
	  
	  if (!params[:sort_by] || !params[:ratings]) && (session[:sort_by] || session[:ratings])
	    flash.keep
	    redirect_to movies_path(sort_by: @sort, ratings: (@filtered_ratings.is_a?(Hash) ? @filtered_ratings.keys : @filtered_ratings))
	  end
	  
	  # Get the sorted list of movies or the filtered list of movies
	  @movies = Movie.where(rating: (@filtered_ratings.is_a?(Hash) ? @filtered_ratings.keys : @filtered_ratings)).order(@sort)
  end

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

end
