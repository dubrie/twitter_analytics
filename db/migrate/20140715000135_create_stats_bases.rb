class CreateStatsBases < ActiveRecord::Migration
  def change
    create_table :stats_bases do |t|

      t.timestamps
    end
  end
end
