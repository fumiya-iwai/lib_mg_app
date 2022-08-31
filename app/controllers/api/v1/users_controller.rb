class Api::V1::UsersController < Api::V1::BaseController

  
    def index
      users = User.all.where(id: current_user).pluck(:point)
      render json: to_api_response(users)
    end
  
  end
  