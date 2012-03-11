class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.select("rating").map(&:rating).uniq
    session[:ratings] ||= @all_ratings
    session[:sort] ||= ''
    @ratings = params[:ratings] ? params[:ratings] : session[:ratings]
    @movies = Movie.order(@sort).where("rating = '#{@ratings}'")
    @sort = %w(title release_date).index(params[:sort]) ? params[:sort] : session[:sort]
  end

  #  def index
  #   # standardize the ratings parameter so it's not a crazy checkbox hash
  #   params[:ratings] = params[:ratings].keys if params[:ratings] && params[:ratings].respond_to?(:keys)

  #   # redirect to saved preferences, if they're there
  #   if !params[:ratings] && !params[:sort_by] && (session[:ratings] || session[:sort_by])
  #     redirect_to action: 'index', ratings: session[:ratings], sort_by: session[:sort_by]
  #   end

  #   # for reference, get a list of every rating
  #   @all_ratings = Movie.select("rating").map(&:rating).uniq

  #   # if there isn't a session, create one
  #   session[:ratings] ||= @all_ratings
  #   session[:sort_by] ||= ''

  #   # selected/cached ratings
  #   @ratings = params[:ratings] ? params[:ratings] : session[:ratings]

  #   # selected/cached sorting preference
  #   # do some control checking to protect against SQL injections
  #   @sort_by = %w(title release_date).index(params[:sort_by]) ? params[:sort_by] : session[:sort_by]

  #   # fetch the movies
  #   @movies = Movie.order(@sort_by).find_all_by_rating(@ratings)

  #   # update the session
  #   session[:ratings] = @ratings
  #   session[:sort_by] = @sort_by
  # end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
