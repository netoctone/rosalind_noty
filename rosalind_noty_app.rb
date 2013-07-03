require 'bundler'
Bundler.setup

require 'sinatra/base'
require 'redis'

require 'sinatra/asset_pipeline'
require 'slim'

class RosalindNotyApp < Sinatra::Base
  register Sinatra::AssetPipeline

  configure do
    set :redis, Redis.new(host: 'localhost', port: 6379)
  end

  get '/' do
    slim :index
  end
end

RosalindNotyApp.use Rack::Auth::Basic do |name, pass|
  name == 'admin' && pass = 'bioruby'
end
