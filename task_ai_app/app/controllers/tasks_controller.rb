# タスク管理を行うコントローラ
#
# タスクの一覧表示、作成、編集、更新、削除、ステータス変更など
# タスクに関する全ての操作を担当する。
#
# @see Task モデルの詳細は Task を参照
class TasksController < ApplicationController
  # ユーザーがログインしているかを確認する
  #
  # @return [void]
  before_action :authenticate_user!

  # タスク一覧を表示する
  #
  # @return [void]
  # @note キーワード検索・ステータス・優先度フィルタ・ソートに対応
  def index
    @tasks = current_user.tasks
                         .search(params[:keyword])
                         .with_status(params[:status])
                         .with_priority(params[:priority])

    # ソート処理
    sort = params[:sort] || "deadline"
    direction = params[:direction] || "asc"

    @tasks = @tasks.order("#{sort} #{direction}")
  end

  # 新規タスク作成フォームを表示する
  #
  # @return [void]
  def new
    @task = Task.new
  end

  # タスクを作成する
  #
  # @return [void]
  # @note 成功時は詳細ページへ、失敗時はフォームを再表示
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to @task, notice: "タスクを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # タスク編集フォームを表示する
  #
  # @return [void]
  def edit
    @task = current_user.tasks.find(params[:id])
  end

  # タスクを更新する
  #
  # @return [void]
  # @note 成功時は詳細ページへ、失敗時はフォームを再表示
  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to task_path(@task), notice: "タスクを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # ステータスのみを更新する（一覧画面からの操作）
  #
  # @return [void]
  def update_status
    @task = current_user.tasks.find(params[:id])

    if @task.update(status: params[:status])
      redirect_to tasks_path, notice: "ステータスを更新しました"
    else
      redirect_to tasks_path, alert: "更新に失敗しました"
    end
  end

  # タスクを削除する
  #
  # @return [void]
  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました"
  end

  # タスク詳細を表示する
  #
  # @return [void]
  def show
    @task = current_user.tasks.find(params[:id])
  end

  private

  # Strong Parameters
  #
  # @return [ActionController::Parameters] 許可されたパラメータ
  # @note 想定時間・実績時間は HH:MM 形式で送られてくる
  def task_params
    params.require(:task).permit(
      :title, :description, :status, :priority,
      :deadline, :estimated_time, :actual_time
    )
  end
end
