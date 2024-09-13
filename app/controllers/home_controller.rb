class HomeController < ApplicationController
  def index
    require "uri"
    require "net/http"

    url = URI("https://#{Rails.application.credentials.api[:url]}/market-trends?trend_type=MARKET_INDEXES&country=us&language=en")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = Rails.application.credentials.api[:key]
    request["x-rapidapi-host"] = Rails.application.credentials.api[:url]

    response = http.request(request)
    @body = response.read_body
  end

  def about_me
  end
end
