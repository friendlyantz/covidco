class ReviewsController < ApplicationController

  def new
    @place = Place.find(params[:place_id])
    @review = Review.new
  end

  def create
    @place = Place.find(params[:place_id])
    @review = Review.new(review_params)
    @review.place = @place
    @review.user = current_user
    # COVID SCORE cals for the PLACE based on reviews

    
    if @review.save && @place.save

      # AVERAGING OUT COVID SCORE FROM REVIEWS

        # VER 1 - old
          # score = ( \
          # 10.0 * @place.reviews.where(covid_rating: 10).count + \
          # 9 * @place.reviews.where(covid_rating: 9).count + \
          # 8 * @place.reviews.where(covid_rating: 8).count + \
          # 7 * @place.reviews.where(covid_rating: 7).count + \
          # 6 * @place.reviews.where(covid_rating: 6).count + \
          # 5 * @place.reviews.where(covid_rating: 5).count + \
          # 4 * @place.reviews.where(covid_rating: 4).count + \
          # 3 * @place.reviews.where(covid_rating: 3).count + \
          # 2 * @place.reviews.where(covid_rating: 2).count + \
          # 1 * @place.reviews.where(covid_rating: 1).count) \
          # / (@place.reviews.all.count)
          # @place.covid_score = score

          # VER 2 WIP/CORRUPTED FORMULA (optimised, but doesnt work properly after seeding)
          if @place.covid_score.nil?
            @place.covid_score = @review.covid_rating
          else
            score = (( @place.reviews.count - 1 ) * @place.covid_score.to_f + @review.covid_rating) / (@place.reviews.count)
            @place.covid_score = score.round(1)
          end
          
        if @place.save
          redirect_to place_path(@place, anchor: "review-#{@review.id}")
        else
          render 'new'
        end
    # FINISHED WITH BREAKING THE BRAIN

    else
      render 'new'
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :covid_rating, :tip, :hand_sanitizer, :face_mask, :temperature_checks, :social_distancing, :contract_tracing, :exposure_risk, :covid_consciousness, :covid_enforcement, :covid_creativity, photos: [] ) #TODO: to be filled with QnA / tips /e tc
  end

end
