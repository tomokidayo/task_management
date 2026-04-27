# アプリケーション全体の基盤となるコントローラ
#
# 全てのコントローラが継承する共通処理を定義する。
# Devise の追加パラメータ許可、ログイン必須設定、ブラウザ制限など
# アプリ全体に関わる設定をまとめている。
class ApplicationController < ActionController::Base
  # Devise コントローラの場合のみ、追加パラメータを許可する
  #
  # @return [void]
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 全てのページでログインを必須にする
  #
  # @return [void]
  before_action :authenticate_user!

  # モダンブラウザのみ許可する（Rails の allow_browser 機能）
  #
  # @return [void]
  allow_browser versions: :modern

  protected

  # Devise のストロングパラメータを拡張する
  #
  # @return [void]
  # @note name を sign_up / account_update で許可する
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  # ログイン後のリダイレクト先を指定する
  #
  # @param resource [User] ログインしたユーザー
  # @return [String] リダイレクト先のパス
  def after_sign_in_path_for(resource)
    tasks_path
  end
end
