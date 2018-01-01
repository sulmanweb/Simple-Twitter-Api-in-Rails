class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.references :user, foreign_key: true
      t.string :utoken, null: false, default: ""
      t.datetime :last_used_at
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :sessions, :utoken, unique: true
    add_index :sessions, :active
  end
end
