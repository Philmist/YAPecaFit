require 'mongo_mapper'

class User
  include MongoMapper::Document

  # key <name>, <type>
  key :username, String
  key :twitter_id, Integer
  key :height, Float
  key :comment, String
  timestamps!
  many :weights, :class_name => "Weights"
end

class Weights
  include MongoMapper::Document

  # key <name>, <type>
  key :twitter_id, Integer
  key :datetime, String
  key :weight, Float
  key :tweet_id, Integer
  key :comment, String
  belongs_to :user, :class_name => "User"
end

