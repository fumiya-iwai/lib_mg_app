class Api::V1::UsersController < Api::V1::BaseController

  def index
    all = User.all
    render json: all.to_json
  end

  def show
    # TODO ユーザを検索する
    render json: { id: 1, name: 'hoge' }
  end

  def create
    # TODO ユーザを作成する
    render body: nil, status: :created
  end
end
