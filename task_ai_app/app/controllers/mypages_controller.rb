class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    # パスワード未入力 → パスワード以外を更新
    if user_params[:password].blank?
      if @user.update(user_params.except(:password, :password_confirmation))
        redirect_to mypage_path, notice: "更新しました"
      else
        render :edit, status: :unprocessable_entity
      end

    # パスワード入力あり → パスワードも更新
    else
      if @user.update(user_params)
        redirect_to mypage_path, notice: "パスワードを更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
