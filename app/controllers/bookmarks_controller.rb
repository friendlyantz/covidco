class BookmarksController < ApplicationController

  def new
    @place = Place.find(params[:place_id])
    @bookmark = Bookmark.new
  end

  def create
    @place = Place.find(params[:place_id])
    @bookmark = Bookmark.new
    @bookmark.place = @place
    @bookmark.user = current_user
    @bookmark.save && @place.save

    respond_to do |format|
      format.html { redirect_to :back}
      # format.json { render json: { places: @places } }
      format.js
    end

    # raise
    # redirect_to place_path(@bookmark.place)
    
  end
  
  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to place_path(@bookmark.place)
  end

end
