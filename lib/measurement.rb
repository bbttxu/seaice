require 'mongo_mapper'

class Measurement
  include MongoMapper::Document
  key :year, Integer, :require => true
  key :day, Integer, :require => true
  key :month, Integer, :require => true
  key :measurement, Integer, :require => true
  key :units, String, :require => true
  timestamps!
end
