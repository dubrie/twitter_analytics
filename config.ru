require 'bundler/setup'
Bundler.require(:default)

require './twheatmaps'

map "/public" do
  run Rack::Directory.new("./public")
end

map "/" do
  run Twheatmaps
end