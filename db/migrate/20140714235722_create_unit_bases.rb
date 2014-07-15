class CreateUnitBases < ActiveRecord::Migration
  def change
    create_table :unit_bases do |t|
      t.integer :total_tweets
      t.integer :total_engagements
      t.integer :total_impressions

      t.timestamps
    end
  end
end
