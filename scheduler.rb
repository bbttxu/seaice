require_relative 'lib/source'
require_relative 'lib/measurement'

require 'open-uri'
require 'csv'
require 'pp'

require 'clockwork'
include Clockwork


# ENV['RACK_ENV'] ||= 'development'

MongoMapper.connection = Mongo::Connection.new( "127.0.0.1", 27017 )
MongoMapper.database = "seaice"


handler do |job|
  # http://www.ijis.iarc.uaf.edu/seaice/extent/plot.csv
  CSV.new(open("http://www.ijis.iarc.uaf.edu/seaice/extent/plot.csv"), :headers => :first_row).each do |line|
    (2002..2012).each do |year|
      
      m = Measurement.find_by_year_and_month_and_day( year, line[0].to_i, line[1].to_i, line[year.to_s].to_i )
      if m
        if m.measurement != line[year.to_s].to_i
          m.measurement = line[year.to_s].to_i
          m.save
          puts "updating existing"
        else
          puts "doing nothing"
        end
      else
        if line[year.to_s].to_i > 0
          m = Measurement.find_or_create_by_year_and_month_and_day_and_measurement( year, line[0].to_i, line[1].to_i, line[year.to_s].to_i )
          puts m
        end
      end
      # if line[year.to_s].to_i > 0
      #   pp m
      # end
    end
  end
end

every(1.hour, 'frequent.job')

