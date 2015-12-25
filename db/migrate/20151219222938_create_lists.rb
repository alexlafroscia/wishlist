class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :title
      t.references :owner, index: true

      t.timestamps null: false
    end
  end
end
