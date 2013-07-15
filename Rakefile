require './rosalind_noty_app'
require 'sinatra/asset_pipeline/task'

Sinatra::AssetPipeline::Task.define! RosalindNotyApp

require './lib/news_checker'

namespace :news do
  desc 'Notify about new Rosalind tasks'
  task :notify do
    begin
      check = NewsChecker.check(RosalindNotyApp.store[:cookies].all)
      [:news, :bad_cookies].each do |check_key|
        store = RosalindNotyApp.store[check_key]

        if check[check_key]
          if store.nil?
            # TODO: email
            store.value = Time.now.to_s
          end
        else
          store.delete
        end
      end
    rescue => e
      msg = "#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}"
      RosalindNotyApp.store[:exceptions].unshift(at: Time.now.to_s, msg: msg)
    end
  end
end
