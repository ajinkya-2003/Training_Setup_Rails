class AddStatusToReservations < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :status, :string
  end
end
