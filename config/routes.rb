# アプリケーションのルーティング設定
#
# 各コントローラへの URL マッピングを定義する。
# Devise のユーザー認証、タスク管理、チャット機能など
# アプリ全体の URL 設計をここで管理する。
Rails.application.routes.draw do
  # --- Devise（ユーザー認証） ---------------------------------------------

  # Devise のルーティング
  devise_for :users

  # ログイン画面をルートに設定
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  # --- タスク管理 ----------------------------------------------------------

  # タスク CRUD + ステータス更新
  #
  # GET    /tasks
  # GET    /tasks/:id
  # POST   /tasks
  # PATCH  /tasks/:id
  # DELETE /tasks/:id
  #
  # PATCH  /tasks/:id/update_status
  resources :tasks do
    patch :update_status, on: :member
  end

  # --- チャット機能 --------------------------------------------------------

  # チャットセッション一覧・詳細・作成
  #
  # GET  /chat_sessions
  # GET  /chat_sessions/:id
  # POST /chat_sessions
  resources :chat_sessions, only: [ :index, :show, :create ] do
    # チャットメッセージ作成
    #
    # POST /chat_sessions/:chat_session_id/chat_messages
    resources :chat_messages, only: [ :create ]
  end

  # --- マイページ -----------------------------------------------------------

  # GET /mypage
  # GET /mypage/edit
  # PATCH /mypage
  resource :mypage, only: [ :show, :edit, :update ]

  # --- Rails 標準ヘルスチェック --------------------------------------------

  get "up" => "rails/health#show", as: :rails_health_check

  # --- PWA 用ルート ---------------------------------------------------------

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
