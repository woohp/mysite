class CreateFilings < ActiveRecord::Migration
  def change
    execute "create extension hstore"

    create_table :filings do |t|
      t.references :company, index: true, null: false
      t.string :sec_link
      t.string :category, null: false
      t.datetime :date, null: false
      t.text :details

      t.timestamps
    end
  end
end
