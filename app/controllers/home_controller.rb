class HomeController < ApplicationController
  def index
    require "uri"
    require "net/http"

    ticker = params[:ticker]

    if ticker
      url = URI("https://#{Rails.application.credentials.api[:url]}/stock-quote?symbol=#{ticker.upcase}%3ANASDAQ&language=en")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-key"] = Rails.application.credentials.api[:key]
      request["x-rapidapi-host"] = Rails.application.credentials.api[:url]

      response = http.request(request)
      body = JSON.parse(response.read_body)

      @stock = body["data"]

      if !@stock["symbol"]
        @stock = "Stock doesn't exist"
      end
    end
  end

  def about_me
  end

  def lookup
    @ticker_req = params[:ticker]

    if @ticker_req == ""
      redirect_to action: "index"
    else
      redirect_to action: "index", ticker: @ticker_req
    end
  end
end
