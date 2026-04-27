class ChangeStatusToIntegerInTasks < ActiveRecord::Migration[7.2]
  def change
        change_column :tasks, :status, :integer, using: 'status::integer'
  end
end
