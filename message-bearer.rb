require 'slack-ruby-client'
require_relative 'slack-bot'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

slack_client_instance = Slack::RealTime::Client.new

SlackBot.new slack_client_instance