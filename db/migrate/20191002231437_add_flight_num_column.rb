class AddFlightNumColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :flights, :flight_num, :integer
  end
end
