class CreateMultiDimensions < ActiveRecord::Migration
  def change
    create_table :multi_dimensions do |t|

      t.timestamps
    end
  end
end
