class RemoveSsnColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :travelers, :ssn
  end
end
