class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.string :day_of_week
      t.integer :day_number

      t.timestamps
    end
  end
end
