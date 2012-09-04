require 'httparty'
require 'sinatra/base'
require 'slim'
require 'coffee-script'

require_relative 'lib/source'
require_relative 'lib/measurement'


class SeaIceData
  include HTTParty
  format :json
  
  def self.year(year = nil)
    JSON.parse( get("http://localhost:9292/1/#{year}.json").body )
  end

  def self.year_month(year = nil, month = nil)
    JSON.parse( get("http://localhost:9292/1/#{year}/#{month}.json").body )
  end
end

class SeaIce < Sinatra::Base 
  
  configure do
    # set :haml, :format => :html5
    set :slim, :pretty => true
    MongoMapper.connection = Mongo::Connection.new( "127.0.0.1", 27017 )
    MongoMapper.database = "seaice"
    # _" + ENV['RACK_ENV']
  end
  
  get '/:year' do  
    measurements = SeaIceData.year(params[:year])    
    slim :year, :locals => { :year => params[:year], :data => measurements}
  end

  get '/:year/:month' do  
    measurements = SeaIceData.year_month(params[:year], params[:month])
    slim :year, :locals => { :year => params[:year], :data => measurements}
  end
end