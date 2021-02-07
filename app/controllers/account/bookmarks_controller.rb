class Account::BookmarksController < ApplicationController
  def index
    @my_bookmarks = current_user.bookmarks
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    # TODO: WIP - trying to implement protection - so only customer can delete.
    # if @bookmark[current_user] == @bookmark[:customer_id])
    @bookmark.destroy

    # TODO: live update after delition. using redirect to my bookmarks for now
    redirect_to account_bookmarks_path
  end
  
end
