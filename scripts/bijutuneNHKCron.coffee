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

        getData = (pday, msg) ->
        
                d = new Date

                year  = d.getFullYear()     # 年（西暦）
                month = d.getMonth() + 1    # 月
                date  = d.getDate() + pday  # 日

                dayStr  = "#{year}-#{pad month, 2}-#{pad date, 2}"
        
                apiUrl = "http://api.nhk.or.jp/v2/pg/list/#{area}/#{service}/#{dayStr}.json?key=#{key}"
                # msg.send "#{apiUrl}"

                dayStrOut  = "#{pad month, 2}-#{pad date, 2}"
        
                request = require "request"

                request apiUrl, (err, response, body) ->
                        # request.get "#{apiUrl}", (err, response, body) ->

                        str = ""
                
                        if err  # プログラムエラー
                                # msg.send "データ取得に失敗しました"
                                # msg.send =  "データ取得に失敗しました"
                                send '#michio_private', "データ取得に失敗しました"

                        if response.statusCode is 200  # 取得成功
                                # JSONとして解釈する
                                try
                                        json = JSON.parse(body)
                                catch e
                                        # msg.send "JSON parse error: #{e}"
                                        send '#michio_private', "JSON parse error: #{e}"

                                # msg.send "#{json.list.e1.length}"

                                icount = 0
                                for num in [0...json.list.e1.length]
                                        # msg.send "#{json.list.e1[num].title[0..7]}"
                                        if json.list.e1[num].title[0..7] is "びじゅチューン！"
                                                # msg.send "#{json.list.e1[num].id}"
                                                icount += 1
                                                str = "びじゅチューンは，#{json.list.e1[num].start_time}から！ \n"
                                                str += "#{json.list.e1[num].title}\n"
                                                str += "#{json.list.e1[num].subtitle}\n"
                                                str += "#{json.list.e1[num].content}"
                                                # msg.send "#{str}"
                                                send '#michio_private', "#{str}"
                                                return
        
                                if icount is 0
                                        # msg.send "#{dayStrOut}はびじゅチューンはありません"
                                        send '#michio_private', "#{dayStrOut}はびじゅチューンはありません"
                
                        else  # APIレスポンスエラー
                                # msg.send "Response error: #{response.statusCode}"
                                send '#michio_private', "Response error: #{response.statusCode}"
                        


        # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
        # generalと言う部屋に、月木の16:10時に実行
        new cronJob('0 21 12 * * *', () ->
                # ↑のほうで宣言しているsendメソッドを実行する
                # msg.send "番組を調べます…"
                pday = 0
                getData pday, msg

                pday = 1
                getData pday, msg
                ).start()


