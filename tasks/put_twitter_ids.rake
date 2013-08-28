require 'mongo_mapper'

task :put_twitter_ids => :environment do
  account = Account.all
  for i in account
    puts "UID: " + i[:uid] + " NAME: " + i[:name] + " ROLE: " + i[:role] + "\n"
  end
end

