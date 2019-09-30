class CreateFlights < ActiveRecord::Migration[5.2]
  def change
    create_table :flights do |t|
      t.string :airline
      t.string :model 
      t.string :origin
      t.string :destination
      t.datetime :departure
      t.datetime :arrival

      t.timestamps null:false
    end
  end
end
