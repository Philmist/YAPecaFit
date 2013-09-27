# vim: fileencoding=utf-8

require 'rubygems'
require 'twitter'
require 'mongo_mapper'

task :followback => :environment do
  cl = Twitter::Client.new(
    :consumer_key => ENV['STAFF_CONS_KEY'],
    :consumer_secret => ENV['STAFF_CONS_SEC'],
    :oauth_token => ENV['STAFF_ACC_KEY'],
    :oauth_token_secret => ENV['STAFF_ACC_SEC']
  )

  followers = cl.follower_ids().all()
  friends = cl.friend_ids().all()
  requests = cl.friendships_outgoing().all()
  
  reqs = []  # Target to send follow request

  for i in followers
    if friends.index(i)  # My account is followed(friends)
      stat = Followstatus.where(:twitter_id => i).first
      unless stat  # not found
        next
      end
      stat.status = "followed"
      puts stat.twitter_id.to_s + " is now friend." if stat.save
    else  # My Account is NOT followed
      if requests.index(i)  # Follow request is pending
        next
      end
      stat = Followstatus.where(:twitter_id => i).first
      if stat  # Follow request is denied by target user
        stat.status = "denied"
        puts "Follow requests to " + stat.twitter_id.to_s + " is denied." if stat.save
      else  # Follow request is not send
        reqs.push(i)
      end
    end
  end

  u = cl.follow(reqs)  # Send follow request
  for i in u
    if i.protected
      stat = Followstatus.new(:twitter_id => i.id, :status => "requested")
      puts "Send follow request to " + i.id.to_s  + " ." if stat.save
    else
      puts "Follow " + i.id.to_s + " ."
    end
  end

end

