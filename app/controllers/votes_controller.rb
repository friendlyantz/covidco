class VotesController < ApplicationController

  def create
    @review = Review.find(params[:review_id])
    @vote = Vote.new
    @vote.review = @review
    @vote.user = current_user
    @vote.save && @review.save
    redirect_to place_path(@review.place, anchor: "review-#{@review.id}" )
  end
  
  def destroy
    @vote = Vote.find(params[:review_id])
    
    # @vote = @review.votes.find_by(user: current_user)
    # TODO: WIP - trying to implement protection - so only customer can delete.
    # if @vote[current_user] == @vote[:customer_id])
    @vote.destroy
    redirect_to place_path(@vote.review.place, anchor: "tips-for-community" )
    # redirect_to place_path(@vote.review.place, anchor: "review-#{@vote.review.id}" )
  end

end
