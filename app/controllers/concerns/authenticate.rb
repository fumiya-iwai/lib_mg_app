module Authenticate
  extend ActiveSupport::Concern

  included do
    include SessionsHelper

    # ログインチェック
    before_action :authenticate_user!
  end

  private

  # ユーザーのログインを確認する
  def authenticate_user!
    unless logged_in?
      redirect_to login_url
    end
  end
end
