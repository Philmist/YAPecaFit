# fileencoding: utf-8
require 'date'
require 'time'

task :generate_testdata => :environment do
  def generate_random_name_list
    def_FIRST_LIST = ["Aaron", "Abel", "Abraham", "Abram", "Basil", "Ben", "Benedict"]
    def_FAMILY_LIST = ["Allen", "Allport", "Allan", "Allison", "Attwell", "Atkins", "Ankerson"]
    res = []
    for i in def_FIRST_LIST
      for j in def_FAMILY_LIST
        res.push i + " " + j
      end
    end
    return res
  end

  def generate_random_height
    return Random.rand(150.0 ... 190.0).round(1)
  end

  def generate_random_weight
    return Random.rand(40.0 ... 90.0).round(1)
  end

  def generate_random_diff
    return Random.rand(-2.0 ... 2.0).round(1)
  end

  initial_date = DateTime.now.new_offset("+0900") << 2  # 2 months ago
  puts "INITIAL DATE : " + initial_date.rfc2822
  names = generate_random_name_list
  for i in names.each_index
    height = generate_random_height
    weight = generate_random_weight
    puts "INITIAL ATTR NAME: " + names[i] + " " + height.to_s + "cm " + weight.to_s + "kg "
    u = User.new(:username => names[i],
                 :twitter_id => i,
                 :height => height,
                 :comment => "TestGeneratedData",
                 :type => "|test|")
    if u.save
      puts "Saved."
    end
    w = Weights.new(:twitter_id => i,
                    :datetime => initial_date.rfc2822,
                    :weight => weight,
                    :tweet_id => (i * 1000000),
                    :comment => "TestGeneratedData")
    w.save
    for j in 1..60
      weight = (weight + generate_random_diff).round(1)
      w = Weights.new(:twitter_id => i,
                      :datetime => (initial_date + j).rfc2822,
                      :weight => weight,
                      :tweet_id => (i * 1000000 + j),
                      :comment => "TestGeneratedData")
      w.save
    end
    puts "FINALLY : " + weight.to_s + "kg at " + (initial_date + 60).rfc2822
  end
end

