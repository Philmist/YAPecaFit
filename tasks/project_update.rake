# fileencoding: utf-8

require 'twitter'
require 'moji'
require 'mongo_mapper'
require 'date'
require 'time'

task :project_show_brief => :environment do
  for i in Project.all
    puts "NAME: " + i[:project_name] + " TYPE: " + i[:project_type]
    puts "CREATOR: " + i[:creator_twitter_name] + "(" + i[:creator_twitter_id].to_s + ")"
    if i[:start_date] and i[:end_date]
      puts "DATE: FROM " + i[:start_date].to_s + " TO " + i[:end_date].to_s
    end
  end
end

task :project_show => :environment do
  for i in Project.all
    puts "PROJ_NAME: " + i[:project_name] + " TYPE: " + i[:project_type]
    puts "CREATOR: " + i[:creator_twitter_name] + "(" + i[:creator_twitter_id].to_s + ")"
    if i[:start_date] and i[:end_date]
      puts "DATE: FROM " + i[:start_date].to_s + " TO " + i[:end_date].to_s
    end
    if i.project_results
      for j in i.project_results
        puts "NAME : " + j[:twitter_name]
        puts "INITIAL : " + (j[:initial_weight] ? j[:initial_weight].to_s : 0.0.to_s) + " FINAL : " + (j[:final_weight] ? j[:final_weight].to_s : 0.0.to_s)
        puts "RESULT : " + (j[:result] ? j[:result].to_s : 0.0.to_s)
      end
    end
  end
end

task :project_destroyall => :environment do
  if Project.destroy_all
    puts "Destroy project done."
  else
    puts "Failed to destroy project."
  end
end

task :project_update => :environment do
  cl = Twitter::Client.new(
    :consumer_key => ENV['STAFF_CONS_KEY'],
    :consumer_secret => ENV['STAFF_CONS_SEC'],
    :oauth_token => ENV['STAFF_ACC_KEY'],
    :oauth_token_secret => ENV['STAFF_ACC_SEC']
  )
  for i in Project.where(:start_date.lte => (Time.now + 60*60*9)).all  # Use JST
    if i[:project_type]['completed']  # Complete project is skipped
      next
    elsif i[:project_type]['open'] and not i[:project_type]['start']
      cl.update("YAPecaFit情報: プロジェクト「" + i.project_name + "」が開始されました")
      i.project_type = i.project_type + "start|"
      i.save
    end
    puts "NAME: " + i[:project_name] + " TYPE: " + i[:project_type]
    puts "CREATOR: " + i[:creator_twitter_name] + "(" + i[:creator_twitter_id].to_s + ")"
    if i[:start_date] and i[:end_date]
      puts "DATE: FROM " + i[:start_date].to_s + " TO " + i[:end_date].to_s
    end
    # Check initial weight
    for j in User.all  # Scan all user
      if i.project_results and i.project_results.select{|k| k.twitter_id == j.twitter_id}.first  # If initial weight exists, we should skip
          next
      end
      first_date = Date.today
      first_weight = 0.0
      for k in Weights.where(:twitter_id => j[:twitter_id]).all  # Scan selected user's weight list
        if Date.parse(k[:datetime]) <= first_date and i[:start_date] <= Date.parse(k[:datetime])
          first_date = Date.parse(k[:datetime])
          first_weight = k[:weight]
        end
      end
      if first_weight == 0.0
        next
      end
      puts "USER: " + j[:username] + " INITIALWEIGHT: " + first_weight.to_s + " at " + first_date.rfc2822
      tmp = ProjectResult.new(:twitter_name => j[:username],
                              :twitter_id => j[:twitter_id],
                              :initial_weight => first_weight)
      i.project_results << tmp
      i.save
    end
    # Check final weight and calculate result
    if i[:end_date] and i[:end_date] <= Date.today  # Check project is finished
      for j in User.all  # Scan all user
        last_date = i[:end_date]
        last_weight = 0.0
        for k in Weights.where(:twitter_id => j[:twitter_id]).all  # Scan selected user's weight list
          if Date.parse(k[:datetime]) >= i[:start_date] and i[:end_date] >= Date.parse(k[:datetime])
            last_date = Date.parse(k[:datetime])
            last_weight = k[:weight]
          end
        end
        if last_weight == 0.0  # maybe not
          next
        end
        puts "USER: " + j.username + " FINALWEIGHT: " + last_weight.to_s + " at " + last_date.rfc2822
        # Calculate Result
        result = 0.0
        if i.project_type and i.project_type['bmi']  # Use BMI
          # TODO: calculate BMI
        else  # Standard method (diff first and last weight)
          result = ((i.project_results.select{|k| k.twitter_id == j.twitter_id}.first[:initial_weight]) - last_weight).abs
          result = result.round(2)
        end
        puts "RESULT: " + result.to_s
        # Save finalweight and result
        if i.project_results.select{|k| k.twitter_id == j.twitter_id}
          data = i.project_results.select{|k| k.twitter_id == j.twitter_id}.first
          data.final_weight = last_weight
          data.result = result
          data.save
        end
      end
      if i.project_type and i.project_type['open']
        cl.update("YAPecaFit情報: プロジェクト「" + i.project_name + "」が終了し、集計完了しました")
      end
      i.project_type = i.project_type + "completed|"
      i.save
    end
  end
end

