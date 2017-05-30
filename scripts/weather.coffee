# Description
#   A Hubot script that tells wether forecasts
#   original: http://kyu-mu.net/coffeescript/howto/2.html
# 
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#  hubot 天気予報 - to know the weather forecasts
#  hubot weather forecast- to know the weather forecasts
#
# Notes:
#
# Author:
#   mchwavy

# cityId一覧: http://weather.livedoor.com/forecast/rss/primary_area.xml
cityId = "130010"  # 東京

apiUrl = "http://weather.livedoor.com/forecast/webservice/json/v1?city=#{cityId}"

module.exports = (robot) ->
        robot.respond /(天気予報|weather forecast)/, (msg) ->

                # msg.send "天気を調べます…"
        
                request = require "request"

                # URLにアクセスしてデータを取得する
                request apiUrl, (err, response, body) ->
                # request.get "#{apiUrl}", (err, response, body) ->

                        if err  # プログラムエラー
                                msg.send "データ取得に失敗しました"
                                return

                        if response.statusCode is 200  # 取得成功
                                # JSONとして解釈する
                                try
                                        json = JSON.parse(body)
                                catch e
                                        msg.send "JSON parse error: #{e}"

                        
                                # 直近の予報データを取得
                                forecast = json.forecasts[json.forecasts.length-2]
                                # msg.send "#{forecast.dateLabel}"

                                # 文を作る
                                weather = "#{json.location.city}の#{forecast.dateLabel}の天気は#{forecast.telop}"

                                if forecast.temperature.max?  # 気温情報がある場合
                                        weather += "、最高気温は#{forecast.temperature.max.celsius}度、" + \
                                          "最低気温は#{forecast.temperature.min.celsius}度"

                                weather += "です。"

                                msg.send weather

                        else  # APIレスポンスエラー
                                msg.send "Response error: #{response.statusCode}"
                                return        
