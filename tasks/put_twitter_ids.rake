require 'mongo_mapper'

task :put_twitter_ids => :environment do
  account = Accounts.all
  for i in account
    put "UID: " + i[:uid] + " NAME: " + i[:name] + " ROLE: " + i[:role] + "\n"
  end
end

