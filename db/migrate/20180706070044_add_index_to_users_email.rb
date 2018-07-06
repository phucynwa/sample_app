class AddIndexToUsersEmail < ActiveRecord::Migration[5.2]
  def change
  	add_index :user, :email, unique: true
  end
end
