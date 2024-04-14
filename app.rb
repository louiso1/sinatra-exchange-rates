require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"
raw_response = HTTP.get(api_url).to_s
parsed_response = JSON.parse(raw_response)
final_hash = parsed_response.fetch("currencies")

get("/") do
  @final_array = []
  final_hash.each_key do |currency|
    @final_array.push(currency)
  end
  erb(:main_page)
end

get("/:from_currency") do
  @currency = params.fetch("from_currency")
  @final_array = []
  final_hash.each_key do |currency|
    @final_array.push(currency)
  end
  erb(:first_request)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url2 = "https://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_RATE_KEY"]}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  raw_response = HTTP.get(api_url2).to_s
  parsed_response = JSON.parse(raw_response)
  @result = parsed_response.fetch("result")
  erb(:second_request)
end
