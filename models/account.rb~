class Account
  include MongoMapper::Document

  # key <name>, <type>
  key :name, String
  key :role, String
  key :uid, String
  key :provider, String
  timestamps!
  def self.create_with_omniauth(auth)
    c = self.new(:provider => auth["provider"],
                 :uid => auth["uid"],
                 :name => auth["user_info"]["name"],
                 :role => "users")
    return c
  end
end
