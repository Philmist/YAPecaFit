# vim: fileencoding=utf-8
class Followstatus
  include MongoMapper::Document

  # key <name>, <type>
  key :twitter_id, Integer
  key :follow_request_time, Time  # Time of sending follow request
  key :status, String  # Should be "requested", "denied", "followed"
  timestamps!
end
