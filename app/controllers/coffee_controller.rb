class CoffeeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def ask
    notifier = Slack::Notifier.new ENV['SLACK_COFFEE_URL']
    notifier.channel = ENV['SLACK_COFFEE_CHANNEL']
    notifier.username = ENV['SLACK_COFFEE_USERNAME']
    @status = notifier.ping '<!channel> Coffee? :coffee:', icon_url: ENV['SLACK_COFFEE_ICON']
  end

  def create
    conn = Faraday.new(:url => ENV['LA_METRIC_URL']) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    body = "{\"frames\":[{\"index\": 0,\"text\": \"#{params['user_name']}: #{params['text']}\"}]}"

    @status = conn.post do |req|
      req.url ENV['LA_METRIC_COFFEE']
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['X-Access-Token'] = ENV['LA_METRIC_TOKEN']
      req.body = body
    end

    sleep(5)

    body = "{\"frames\":[{\"index\": 0,\"text\": \"Coffee\",\"icon\":\"a1311\"}]}"

    @status = conn.post do |req|
      req.url ENV['LA_METRIC_COFFEE']
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['X-Access-Token'] = ENV['LA_METRIC_TOKEN']
      req.body = body
    end
  end
end
