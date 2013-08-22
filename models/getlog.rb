class Getlog
  include MongoMapper::Document

  # key <name>, <type>
  key :tweet_id, Integer
  timestamps!
end
