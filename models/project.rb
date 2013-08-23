class Project
  include MongoMapper::Document

  # key <name>, <type>
  key :proj_name, String, :required => true
  key :proj_type, String, :required => true
  key :creator_twitter_id, Integer
  key :creator_twitter_name, String
  key :startdate, Date
  key :enddate, Date
  many :proj_results
  timestamps!
end

class ProjectResult
  include MongoMapper::EmbeddedDocument
  key :name, String
  key :twitter_id, Integer
  key :initial, Float
  key :final, Float
  key :result, Float
end

