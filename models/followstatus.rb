# vim: fileencoding=utf-8
class Followstatus
  include MongoMapper::Document

  # key <name>, <type>
  key :twitter_id, Integer
  key :status, String  # Should be "requested", "denied", "followed"
  timestamps!
end
