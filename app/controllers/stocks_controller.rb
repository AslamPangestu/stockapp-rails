class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show edit update destroy ]
  before_action :correct_user, only: [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user!

  # GET /stocks or /stocks.json
  def index
    # @stocks=[]

    @stocks = Stock.where(user_id: current_user.id)
    # stocks.each do |stock|
    #   data = detail(stock.ticker)
    #   @stocks.push(data)
    # end
  end

  # GET /stocks/1 or /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks or /stocks.json
  def create
    @stock = Stock.new(stock_params)
    @stock["user_id"] = current_user.id

    puts @stock.user_id

    respond_to do |format|
      if @stock.save
        format.html { redirect_to stock_url(@stock), notice: "Stock was successfully created." }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1 or /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to stock_url(@stock), notice: "Stock was successfully updated." }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1 or /stocks/1.json
  def destroy
    @stock.destroy!

    respond_to do |format|
      format.html { redirect_to stocks_url, notice: "Stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def correct_user
    @ticker = current_user.stocks.find_by(id: params[:id])
    redirect_to stocks_path, notice: "Not authorized to edit this stock" if @ticker.nil?
  end

  def detail(ticker)
    require "uri"
    require "net/http"

    if ticker
      url = URI("https://#{Rails.application.credentials.api[:url]}/stock-quote?symbol=#{ticker.upcase}%3ANASDAQ&language=en")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-key"] = Rails.application.credentials.api[:key]
      request["x-rapidapi-host"] = Rails.application.credentials.api[:url]

      response = http.request(request)
      body = JSON.parse(response.read_body)

      stock = body["data"]

      if !stock["symbol"]
       return nil
      end
      stock
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:ticker)
    end
end
