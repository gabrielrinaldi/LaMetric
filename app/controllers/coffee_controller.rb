class CoffeeController < ApplicationController
  def ask
    notifier = Slack::Notifier.new ENV['SLACK_COFFEE_URL']
    notifier.channel = ENV['SLACK_COFFEE_CHANNEL']
    notifier.username = ENV['SLACK_COFFEE_USERNAME']
    @status = notifier.ping 'Coffee? :coffee:'
  end
end
