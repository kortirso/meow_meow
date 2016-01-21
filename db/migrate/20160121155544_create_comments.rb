class CreateComments < ActiveRecord::Migration
    def change
        create_table :comments do |t|
            t.text :body
            t.integer :user_id
            t.integer :pet_id
            t.timestamps null: false
        end
        add_index :comments, :user_id
        add_index :comments, :pet_id
    end
end
