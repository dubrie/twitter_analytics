class CreateDayStats < ActiveRecord::Migration
  def change
    create_table :day_stats do |t|

      t.timestamps
    end
  end
end
