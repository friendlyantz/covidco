class PlacesController < ApplicationController
 skip_before_action :authenticate_user!, only: :index
 

  def index

    # SEARCH
    if params[:query].present?
      @places = Place.search_by_name_description_category(params[:query])
      if params[:tags].present?
        @places = @places.tagged_with(params[:tags])
      end
    elsif params[:tags].present?
      @places = Place.tagged_with(params[:tags])
    else
      @places = []
    end

    # MAPBOX
    if @places == []
      @markers = {}
    else
      @markers = @places.geocoded.map do |place|
        {
          lat: place.latitude,
          lng: place.longitude,
          infoWindow: render_to_string(partial: "info_window", locals: { place: place }),
          image_url: helpers.asset_url('icon_restaurant.png')
        }
      end
    end

  end

  def show
    @place = Place.find(params[:id])
    
    # MAPBOX
    @markers = [{
        lat: @place.latitude,
        lng: @place.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { place: @place }),
        image_url: helpers.asset_url('icon_restaurant.png')
      }]
    

    @related_places = @place.find_related_tags

    @review = Review.new  
  end

  def tagged
    if params[:tag].present?
      @places = Place.tagged_with(params[:tag])
    else
      @places = Place.all
    end
  end

  def map
    # SEARCH
    if params[:query].present?
      @places = Place.search_by_name_address_description_tags(params[:query])
      if params[:tags].present?
        @places = @places.tagged_with(params[:tags])
      end
    elsif params[:tags].present?
      @places = Place.tagged_with(params[:tags])
    else
      # RETURNING ALL
      @places = Place.all
    end

    # MAPBOX
    if @places == []
      @markers = {}
    else
      @markers = @places.geocoded.map do |place|
        {
          lat: place.latitude,
          lng: place.longitude,
          infoWindow: render_to_string(partial: "info_window", locals: { place: place }),
          image_url: helpers.asset_url('icon_restaurant.png')
        }
      end
    end
  end
  
  private

  def places_params
    params.require(:place).permit(:name, :description, tag_list: [], photos: [])  # input tags as multi-select list or as checkboxes
  end

end
