require './seaice'
require './seaiceapi'
# require 'rack/tidy'
# use Rack::Tidy

map "/" do
  run SeaIce
end

map "/1/" do
  run SeaIceApi
end