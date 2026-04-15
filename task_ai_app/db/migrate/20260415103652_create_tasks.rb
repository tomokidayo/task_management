class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :status
      t.integer :priority
      t.datetime :deadline
      t.integer :estimated_time
      t.integer :actual_time

      t.timestamps
    end
  end
end
