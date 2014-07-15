class CreateMultiDimensionStats < ActiveRecord::Migration
  def change
    create_table :multi_dimension_stats do |t|

      t.timestamps
    end
  end
end
