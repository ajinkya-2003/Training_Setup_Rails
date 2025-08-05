class ChangeDefaultRoleTypeToCustomer < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :role_type, from: 1, to: 3
  end
end
