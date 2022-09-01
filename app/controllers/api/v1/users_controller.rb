class Api::V1::UsersController < Api::V1::BaseController
  
    def index
      users = User.all.where(id: 7).pluck(:point)
      #users = User.all.where(id: current_user.id).pluck(:point) なぜカレントidを呼べないのか
      render json: to_api_response(users)
    end
  
end
  