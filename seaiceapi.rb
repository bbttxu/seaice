require 'sinatra/base'

require_relative 'lib/source'
require_relative 'lib/measurement'


class SeaIceApi < Sinatra::Base 

  before do
    content_type "application/json"
  end
  
  configure do
    MongoMapper.connection = Mongo::Connection.new( "127.0.0.1", 27017 )
    MongoMapper.database = "seaice"
    # _" + ENV['RACK_ENV']
  end
  
  get '/all.json' do
    Measurement.where(:year => params[:year].to_i).fields(:year, :month, :day, :measurement).sort( :year.asc, :month.asc, :day.asc).to_json
  end

  get '/:year.json' do
    Measurement.where(:year => params[:year].to_i).fields(:year, :month, :day, :measurement).sort( :year.asc, :month.asc, :day.asc).to_json
  end

  get '/:year/:month.json' do
    Measurement.where(:year => params[:year].to_i,:month => params[:month].to_i).fields(:year, :month, :day, :measurement).sort( :year.asc, :month.asc, :day.asc).to_json
  end
end