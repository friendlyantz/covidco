class PagesController < ApplicationController
  # Protect every route by default!
  skip_before_action :authenticate_user!, only: :home
  def home
    @places = Place.all

    # MAPBOX
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
