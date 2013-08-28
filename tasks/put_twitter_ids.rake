require 'mongo_mapper'

task :put_twitter_ids => :environment do
  account = Account.all
  for i in account
    puts "UID: " + i[:uid] + " NAME: " + i[:name] + " ROLE: " + i[:role] + "\n"
  end
end

task :delete_duplicate_accounts => :environment do
  puts "Wait..."
  Account.ensure_index [[:uid, 1], [:provider, 1]], :unique => true, :dropDups => true
  puts "Done."
end

