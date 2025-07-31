# db/migrate/XXXXXXXXXXXXXX_add_role_type_and_status_to_users.rb
class AddRoleTypeAndStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role_type, :integer, default: 1, null: false
    add_column :users, :status, :integer, default: 1, null: false
  end
end
