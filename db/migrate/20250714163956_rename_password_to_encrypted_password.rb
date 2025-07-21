class RenamePasswordToEncryptedPassword < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :password, :encrypted_password
  end
end
