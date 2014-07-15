# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140715051805) do

  create_table "ascii_chart_multi_dimensions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ascii_charts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "day_stats", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "days", force: true do |t|
    t.string   "day_of_week"
    t.integer  "day_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hours", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "multi_dimension_stats", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "multi_dimensions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stats_bases", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unit_bases", force: true do |t|
    t.integer  "total_tweets"
    t.integer  "total_engagements"
    t.integer  "total_impressions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
