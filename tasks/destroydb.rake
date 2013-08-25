require 'mongo_mapper'

task :destroydb => :environment do

  puts "Destroy User collection..."
  if User.destroy_all
    puts "done.\n"
  else
    puts "failed.\n"
  end

  puts "Destroy Weights collection..."
  if Weights.destroy_all
    puts "done.\n"
  else
    puts "failed.\n"
  end

  puts "Destroy Account collection..."
  if Account.destroy_all
    puts "done.\n"
  else
    puts "failed.\n"
  end

  puts "Destroy Twitter get log collection..."
  if Getlog.destroy_all
    puts "done.\n"
  else
    puts "failed.\n"
  end

end



