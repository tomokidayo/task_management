class TasksController < ApplicationController
  before_action :authenticate_user!

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

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to @task, notice: "タスクを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to task_path(@task), notice: "タスクを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    @task = current_user.tasks.find(params[:id])

    if @task.update(status: params[:status])
      redirect_to tasks_path, notice: "ステータスを更新しました"
    else
      redirect_to tasks_path, alert: "更新に失敗しました"
    end
  end


  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました"
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end



  private

  def task_params
    params.require(:task).permit(
      :title, :description, :status, :priority,
      :deadline, :estimated_time, :actual_time
    )
  end
end
