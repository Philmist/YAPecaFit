# vim: fileencoding: utf-8

require 'twitter'
require 'moji'
require 'mongo_mapper'
require 'date'
require 'time'

task :project_show => :environment do
  for i in Project.all
    puts "NAME: " + i[:project_name] + " TYPE: " + i[:project_type]
    puts "CREATOR: " + i[:creator_twitter_name] + "(" + i[:creator_twitter_id].to_i + ")"
    if i[:start_date] and i[:end_date]
      puts "DATE: FROM " + i[:start_date].to_s + " TO " + i[:end_date].to_s
    end
  end
end

