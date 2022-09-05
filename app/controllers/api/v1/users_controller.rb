class Api::V1::UsersController < Api::V1::BaseController
  
    def point
      user = User.find(current_user.id)
      render json: { point: user.point }
    end

end
  