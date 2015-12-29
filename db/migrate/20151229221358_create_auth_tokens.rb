class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.string :value, unique: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_index :auth_tokens, :value, unique: true

    remove_column :users, :auth_token, :string
  end
end
