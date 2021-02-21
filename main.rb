require 'os'
require 'httparty'
args = ARGV

puts args
@fiat = args[1]
@crypto = args[0]
@target_price = args[2] || 0
def alert
  if (OS.mac?)
    system('afplay alert.mp3')
  elsif (OS.linux?)
    system("mpg123 alert.mp3")
  end
end
def get_cmc_data()

  headers = {
    "X-CMC_PRO_API_KEY"=> '0b76a90a-8a70-4d65-9153-6857210556a5'
  }
  query = {
    "start" => "1",
    "convert" => @fiat
  }
  req = HTTParty.get('https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest', :headers => headers, :query => query)
  data = req.body
  return data
end

@cmc_data = JSON.parse(get_cmc_data,  {:symbolize_names=>true})


@currency = @cmc_data[:data].find{|k| k[:symbol] === @crypto}[:quote][:"#{@fiat}"]

if (@currency)
  puts '🚀 Currency found'
  if (@currency[:percent_change_24h] <= @target_price.to_f)
    alert
    puts "☠ #{@crypto} is down #{@currency[:percent_change_24h]}"
  else
    puts "🚀🌕 ~ #{@crypto} is going to the mooooooon"
    puts "🚀🌕 #{@currency[:percent_change_24h]} over the last 24h"
  end
else
  puts '❌ Currency not found'
end

