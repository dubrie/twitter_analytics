class CreateAsciiCharts < ActiveRecord::Migration
  def change
    create_table :ascii_charts do |t|

      t.timestamps
    end
  end
end
