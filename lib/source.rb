require 'mongo_mapper'

class Source
  include MongoMapper::Document
  key :name, String, :require => true
  many :measurements
end
