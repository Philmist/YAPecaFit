require 'mongo_mapper'

class User
  include MongoMapper::Document

  # key <name>, <type>
  key :username, String
  key :twitter_id, Integer, :required => true
  key :height, Float
  key :comment, String
  key :type, String
  timestamps!
  many :weights, :class_name => "Weights"
end

class Weights
  include MongoMapper::Document

  # key <name>, <type>
  key :twitter_id, Integer, :required => true
  key :datetime, String
  key :weight, Float, :required => true
  key :tweet_id, Integer, :required => true
  key :comment, String
  belongs_to :user, :class_name => "User"
end

