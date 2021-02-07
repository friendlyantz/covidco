class UsersController < ApplicationController

    def edit
        @user = current_user
    end
    
    def update        
        @user = current_user
        # @user.update(user_params)

        if @user.update(user_params)
            redirect_to @user
        else
          render 'edit'
        end
    end

    private

    def user_params
        params.require(:user).permit(:first_name, :location_id)
    end
    

end
