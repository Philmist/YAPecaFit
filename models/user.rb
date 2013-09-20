require 'mongo_mapper'

class User
  include MongoMapper::Document

  # key <name>, <type>
  key :username, String
  key :twitter_id, Integer, :required => true
  key :height, Float  # [cm]
  key :comment, String
  key :type, String
  timestamps!
  many :weights, :class_name => "Weights"
end

class Weights
  include MongoMapper::Document

  # key <name>, <type>
  key :twitter_id, Integer, :required => true
  key :datetime, String  # Should be rfc2822
  key :weight, Float, :required => true  # [kg]
  key :tweet_id, Integer, :required => true
  key :comment, String
  belongs_to :user, :class_name => "User"
end

