class SessionsController < ApplicationController
  # ログインページ・ログインではログインチェックをスキップ
  skip_before_action :authenticate_user!, only: [:new, :create]

  # ログインページ
  def new
  end

  # ログイン
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to main_url
    else
      render 'new'
    end
  end

  # ログアウト
  def destroy
    log_out
    redirect_to login_url
  end
end
