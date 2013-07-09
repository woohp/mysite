class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.references :user
      t.string :title
      t.text :description
      t.integer :status_cd

      t.timestamps
    end
    add_index :todos, :user_id
  end
end
