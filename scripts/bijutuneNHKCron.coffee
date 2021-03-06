# Description
#   A Hubot script that tells NHK program info.
#
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#
# Notes:
#
# Author:
#   mchwavy

# cityId一覧: http://weather.livedoor.com/forecast/rss/primary_area.xml
# URLにアクセスしてデータを取得する
area = "130"  # 東京
service = "e1"  # Eテレ
key = process.env.HUBOT_NHK_KEY
sChannel = "#tv"

pad = (num, width) ->
        num += ""
        while num.length < width
                num = "0" + num
        num

cronJob = require('cron').CronJob

module.exports = (robot) ->

        # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
        send = (channel, msg) ->
                robot.send {room: channel}, msg

        getData = (pday) ->
        
                d = new Date

                year  = d.getFullYear()     # 年（西暦）
                month = d.getMonth() + 1    # 月
                date  = d.getDate() + pday  # 日
                dayOfWeek = d.getDay()      # 曜日
                dayOfWeekStr = ["日", "月", "火", "水", "木", "金", "土"]
                dayStr  = "#{year}-#{pad month, 2}-#{pad date, 2}"
        
                apiUrl = "http://api.nhk.or.jp/v2/pg/list/#{area}/#{service}/#{dayStr}.json?key=#{key}"
                # send "#{sChannel}", "#{apiUrl}"

                dayStrOut  = "#{pad month, 2}-#{pad date, 2} (#{dayOfWeekStr[dayOfWeek]})"
        
                request = require "request"

                request apiUrl, (err, response, body) ->
                        # request.get "#{apiUrl}", (err, response, body) ->

                        str = ""
                
                        if err  # プログラムエラー
                                send "#{sChannel}", "データ取得に失敗しました"

                        if response.statusCode is 200  # 取得成功
                                # JSONとして解釈する
                                try
                                        json = JSON.parse(body)
                                catch e
                                        send "#{sChannel}", "JSON parse error: #{e}"

                                # msg.send "#{json.list.e1.length}"

                                icount = 0
                                for num in [0...json.list.e1.length]
                                        # msg.send "#{json.list.e1[num].title[0..7]}"
                                        if json.list.e1[num].title[0..7] is "びじゅチューン！"
                                                # msg.send "#{json.list.e1[num].id}"
                                                icount += 1
                                                str = "びじゅチューンは，#{json.list.e1[num].start_time}から！ \n"
                                                str += "#{json.list.e1[num].title}\n"
                                                # str += "#{json.list.e1[num].subtitle}\n"
                                                str += "#{json.list.e1[num].content}"
                                                send "#{sChannel}", "#{str}"
                                                return
        
                                if icount is 0
                                        send "#{sChannel}", "#{dayStrOut}はびじゅチューンはありません"
                
                        else  # APIレスポンスエラー
                                send "#{sChannel}", "Response error: #{response.statusCode}"
                        


        # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
        # tvと言う部屋に、月木の16:10時に実行
        new cronJob('0 0 18 * * 2', () ->
                # ↑のほうで宣言しているsendメソッドを実行する
                send "#{sChannel}", "今日のびじゅチューンを調べます…"
                pday = 0
                getData pday, sChannel

                send "#{sChannel}", "明日のびじゅチューンを調べます…"
                pday = 1
                getData pday, sChannel
                ).start()


