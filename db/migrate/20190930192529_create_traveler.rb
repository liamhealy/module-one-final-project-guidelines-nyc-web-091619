class CreateTraveler < ActiveRecord::Migration[5.2]
  def change
    create_table :travelers do |t|
      t.string :name
      t.string :ssn
    end
  end
end
