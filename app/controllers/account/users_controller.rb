class Account::UsersController < ApplicationController
  def index
    @my_details = current_user
  end
end
