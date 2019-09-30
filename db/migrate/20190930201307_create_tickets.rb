class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.integer :traveler_id
      t.integer :flight_id

      t.timestamps null:false
    end
  end
end
