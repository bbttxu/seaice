require 'httparty'
require 'sinatra/base'
require 'slim'
require 'coffee-script'
require 'sass'

require_relative 'lib/source'
require_relative 'lib/measurement'
require_relative 'lib/linearregression'


class Float
  def precision(p)
    # Make sure the precision level is actually an integer and > 0
    raise ArgumentError, "#{p} is an invalid precision level. Valid ranges are integers > 0." unless p.class == Fixnum or p < 0
    # Special case for 0 precision so it returns a Fixnum and thus doesn't have a trailing .0
    return self.round if p == 0
    # Standard case  
    return (self * 10**p).round.to_f / 10**p
  end
  
end

class SeaIceData
  include HTTParty
  format :json
  
  def self.year(year = nil)
    JSON.parse( get("http://localhost:9292/1/#{year}.json").body )
  end

  def self.year_month(year = nil, month = nil)
    JSON.parse( get("http://localhost:9292/1/#{year}/#{month}.json").body )
  end

  def self.year_month_day(year = nil, month = nil, day = nil)
    JSON.parse( get("http://localhost:9292/1/#{year}/#{month}/#{day}.json").body )
  end

  def self.month_day( month = nil, day = nil)
    JSON.parse( get("http://localhost:9292/1/year/#{month}/#{day}.json").body )
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
  
  get "/css/application.css" do
    content_type 'text/css'
    sass :"css/application" #, :sass => Compass.sass_engine_options
  end

  get '/:year' do  
    measurements = SeaIceData.year(params[:year])    
    slim :year, :locals => { :year => params[:year], :data => measurements}
  end

  get '/:year/:month' do  
    measurements = SeaIceData.year_month(params[:year], params[:month])
    slim :month, :locals => { :year => params[:year], :month => params[:month], :data => measurements}
  end

  get '/:year/:month/:day' do  
    measurements = SeaIceData.year_month_day(params[:year], params[:month], params[:day])
    all_years = SeaIceData.month_day( params[:month], params[:day])
    slim :historical, :locals => { :year => params[:year], :month => params[:month], :day => params[:day], :data => measurements, :historical => all_years}
  end

end