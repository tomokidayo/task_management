# マイページに関する操作を管理するコントローラー
#
# ユーザーのプロフィール表示・編集・更新を担当する。
# すべてのアクションに認証が必要。
class MypagesController < ApplicationController
  before_action :authenticate_user!

  # マイページを表示する
  #
  # @return [void]
  def show
    @user = current_user
  end

  # マイページの編集フォームを表示する
  #
  # @return [void]
  def edit
    @user = current_user
  end

  # ユーザー情報を更新する
  #
  # パスワードが入力されていない場合はパスワード以外のフィールドのみ更新する。
  # パスワードが入力されている場合はすべてのフィールドを更新する。
  # 更新成功時はマイページへリダイレクト、失敗時は編集フォームを再描画する。
  #
  # @return [void]
  def update
    @user = current_user

    if user_params[:password].blank?
      if @user.update(user_params.except(:password, :password_confirmation))
        redirect_to mypage_path, notice: "更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
    else
      if @user.update(user_params)
        redirect_to mypage_path, notice: "パスワードを更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  # ユーザー情報更新に使用するパラメーターを許可する
  #
  # @return [ActionController::Parameters] 許可されたパラメーター
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
