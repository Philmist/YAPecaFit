class Project
  include MongoMapper::Document

  # key <name>, <type>
  key :project_name, String, :required => true
  key :project_type, String, :required => true
  key :creator_twitter_id, Integer, :required => true
  key :creator_twitter_name, String
  key :start_date, Date
  key :end_date, Date
  many :project_results, :class_name => "ProjectResult"
  timestamps!
end

class ProjectResult
  include MongoMapper::EmbeddedDocument
  key :twitter_name, String
  key :twitter_id, Integer
  key :initial_weight, Float
  key :final_weight, Float
  key :result, Float
  embedded_in :Project
end

