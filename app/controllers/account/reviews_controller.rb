class Account::ReviewsController < ApplicationController
  
  def index
    @my_reviews = current_user.reviews
  end

end
