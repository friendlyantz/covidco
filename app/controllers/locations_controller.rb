class LocationsController < ApplicationController
  before_action :authenticate_user!
  def search
    # if user_signed_in?
      @location = current_user.location

    # @places = @location.places
    # SEARCH
    if params[:query].present?
      @places = @location.places.search_by_name_description_category(params[:query])
      if params[:tags].present?
        @places = @places.tagged_with(params[:tags])
      end
    elsif params[:tags].present?
      @places = @location.places.tagged_with(params[:tags])
    else
      @places = @location.places
    end
  end

  def map
    # SEARCH
    if params[:query].present?
      @places = @location.places.search_by_name_address_description_tags(params[:query])
      if params[:tags].present?
        @places = @places.tagged_with(params[:tags])
      end
    elsif params[:tags].present?
      @places = @location.places.tagged_with(params[:tags])
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

  def show
    @location = current_user.location
    @places = @location.places

    @activities = Place.tagged_with("Activity")
    # @location.places.where(category: "[\"Activity\"]")


    if params[:query].present?
      @places = @location.places.search_by_name_description_category(params[:query])
      if params[:tags].present?
        @places = @places.tagged_with(params[:tags])
      end
    elsif params[:tags].present?
      @places = @location.places.tagged_with(params[:tags])
    else
      @places = @location.places
    end

  end
end
