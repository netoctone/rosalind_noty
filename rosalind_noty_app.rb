require 'bundler'
Bundler.setup

require 'sinatra/base'
require 'redis-objects'

require 'sinatra/asset_pipeline'
require 'skim'
require 'slim'

class RosalindNotyApp < Sinatra::Base
  register Sinatra::AssetPipeline

  configure do
    Redis::Objects.redis = Redis.new(host: 'localhost', port: 6379)
    set :store, {
      news: Redis::Value.new('rosalind_noty:news'),
      cookies: Redis::HashKey.new('rosalind_noty:cookies'),
      bad_cookies: Redis::Value.new('rosalind_noty:bad_cookies'),
      exceptions: Redis::List.new('rosalind_noty:exceptions', marshal: true)
    }
  end

  get '/' do
    slim :index
  end

  post '/cookie' do
    settings.store[:cookies].tap do |cs|
      cs.clear
      cs.bulk_set(params[:cookies])
    end
  end
end

RosalindNotyApp.use Rack::Auth::Basic do |name, pass|
  name == 'admin' && pass = 'bioruby'
end
