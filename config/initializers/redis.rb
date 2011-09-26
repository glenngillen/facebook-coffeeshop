require "redis"
begin
  uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost/")
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
rescue Exception
end
