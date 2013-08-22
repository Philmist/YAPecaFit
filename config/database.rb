unless ENV['MONGOHQ_URL']
  MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)
  case Padrino.env
  when :development then MongoMapper.database = 'yapecafit_development'
  when :production  then MongoMapper.database = 'yapecafit_production'
  when :test        then MongoMapper.database = 'yapecafit_test'
  end
else
  uri = URI.parse(ENV['MONGOHQ_URL'])
  MongoMapper.connection = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'], :logger => logger)
  MongoMapper.database = uri.path.gsub(/^\//, '')
end


