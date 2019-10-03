class DeleteAirlineAndModel < ActiveRecord::Migration[5.2]
  def change
    remove_column :flights, :airline
    remove_column :flights, :model
  end
end
