class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|

      t.timestamps
    end
  end
end
