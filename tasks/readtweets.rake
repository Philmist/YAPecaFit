# vim: fileencoding=utf-8
require 'twitter'
require 'moji'
require 'date'
require 'mongo_mapper'
require 'time'

task :readbody => :environment do

  def str_to_weight(s)
    t = Moji.zen_to_han(s)
    if /(\d+\.?\d*)\s*[Kk][Gg]/ =~ t
      return Regexp.last_match[0].to_f
    else
      return nil
    end
  end

  def str_to_height(s)
    t = Moji.zen_to_han(s)
    if /(\d+\.?\d*)\s*[Cc][Mm]/ =~ t
      return Regexp.last_match[0].to_f
    else
      return nil
    end
  end

  def utc_to_jststr(t)
    DateTime.rfc2822( t.rfc2822 ).new_offset("+0900").rfc2822
  end


  cl = Twitter::Client.new(
    :consumer_key => ENV['STAFF_CONS_KEY'],
    :consumer_secret => ENV['STAFF_CONS_SEC'],
    :oauth_token => ENV['STAFF_ACC_KEY'],
    :oauth_token_secret => ENV['STAFF_ACC_SEC']
  )
  puts "Count: " + Getlog.count.to_s + "\n"
  if Getlog.count > 300
    Getlog.sort(:order => :created_at.desc).skip(300).destroy
  end
  log_last = Getlog.last(:order => :created_at.asc)
  unless log_last
    puts "Database_Getlog : nil\n"
  else
    puts "Database_Getlog : " + log_last.tweet_id.to_s + "\n"
  end
  since = log_last.tweet_id if log_last
  unless since
    since = 1  # from start
  end
  mentions = cl.mentions_timeline(:since_id => since)
  update_count = 0
  new_count = 0
  for i in mentions.reverse
    res = i.text + " from " + i.user.name + "(" + i.user.id.to_s + ")" + " : " + i.id.to_s + "\n"
    unless str_to_weight(i.text) or str_to_height(i.text)
      puts res
      next
    end
    if str_to_height(i.text)
      res = res + str_to_height(i.text).to_s + "cm "
      unless User.first(:twitter_id => i.user.id)  # New User
        unless str_to_weight(i.text)
          next
        end
        data = User.new(:twitter_id => i.user.id,
                        :username => i.user.name,
                        :height => str_to_height(i.text),
                        :comment => "")
        c = Weights.new(:twitter_id => i.user.id,
                        :datetime => utc_to_jststr( i.created_at ),
                        :weight => str_to_weight(i.text),
                        :tweet_id => i.id,
                        :user => data )
        if data.save and c.save
          res = res + "(N) " + str_to_weight(i.text).to_s + "kg (N)"
          new_count = new_count + 1
        end
      else  # Exist User
        if User.set({:twitter_id => i.user.id}, :username => i.user.name, :height => str_to_height(i.text))
          res = res + "(U) "
        end
      end
    elsif str_to_weight(i.text)
      res = res + str_to_weight(i.text).to_s + "kg "
      unless User.last(:twitter_id => i.user.id)
        res = res + "(n) "
      else
        c = User.last(:twitter_id => i.user.id)
        data = Weights.new(:twitter_id => i.user.id,
                           :datetime => utc_to_jststr( i.created_at ),
                           :weight => str_to_weight(i.text),
                           :tweet_id => i.id,
                           :user => c )
        if data.save
          res = res + "(S) "
          update_count = update_count + 1
        end
      end
    end
    res = res + "\n"
    puts res
  end
  # puts since.to_s + "\n"
  if mentions[-1]
    last_log = Getlog.new(:tweet_id => mentions[0].id)
    if last_log.save
      puts "Last Twitter ID Saved!\n"
    end
  end
#  if update_count > 0 or new_count > 0
#    cl.update("YAPecaFit情報：" + update_count.to_s + "件を更新し、" + new_count.to_s + "件を追加しました。") rescue puts "Tweet error occured."
#  end
end

