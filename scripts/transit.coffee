# Description
#   A Hubot script that tells transit information
# 
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#  全国の鉄道遅延 - 全国の鉄道遅延情報．
#  鉄道遅延 - ご指定の列車の遅延情報．(列車はプログラム内で指定)
#
# Notes:
#
# Author:
#   mchwavy

trainList =
        "京浜東北線" : "JR東日本"
        "常磐線" : "JR東日本"
        "常磐線快速電車" : "JR東日本"
        "常磐線各駅停車" : "JR東日本"
        "南北線" : "東京メトロ"
        "つくばエクスプレス線" : "つくばエクスプレス"

apiUrl = "https://rti-giken.jp/fhc/api/train_tetsudo/delay.json"

module.exports = (robot) ->
        robot.hear /^全国の鉄道遅延/, (msg) ->

                # msg.send "電車の遅延状況を調べます…"
        
                request = require "request"

                # URLにアクセスしてデータを取得する
                request apiUrl, (err, response, body) ->
                # request.get "#{apiUrl}", (err, response, body) ->

                        if err
                                msg.send "データ取得に失敗しました"
                                return

                        if response.statusCode is 200  # 取得成功
                                # JSONとして解釈する
                                try
                                        json = JSON.parse(body)
                                catch e
                                        msg.send "JSON parse error: #{e}"

                                # msg.send "#{json.length}"
                                # msg.send "#{json[0].name}"

                                d = new Date

                                if json.length is 0
                                        msg.send "#{d.getHours()}時#{d.getMinutes()}分現在，遅れている列車はありません"
                                else
                                        troubleList =""
                                        troubleList="#{d.getHours()}時#{d.getMinutes()}分現在，遅れている列車は以下の通りです…\n"
                                        for num in [0...json.length]
                                                troubleList +="#{json[num].company} 「#{json[num].name}」"
                                                if num < json.length-1
                                                        troubleList += "， "
                                        msg.send troubleList
                        else  # APIレスポンスエラー
                                msg.send "Response error: #{response.statusCode}"
                                return


        robot.hear /^鉄道遅延/, (msg) ->

                # msg.send "電車の遅延状況を調べます…"
        
                request = require "request"

                # URLにアクセスしてデータを取得する
                request apiUrl, (err, response, body) ->

                        if err
                                msg.send "データ取得に失敗しました"
                                return

                        if response.statusCode is 200  # 取得成功
                                # JSONとして解釈する
                                try
                                        json = JSON.parse(body)
                                catch e
                                        msg.send "JSON parse error: #{e}"

                                # msg.send "#{json.length}"
                                # msg.send "#{json[0].name}"

                                d = new Date

                                delayedInList = 0
                                if json.length is 0
                                        msg.send "#{d.getHours()}時#{d.getMinutes()}分現在，遅れている列車はありません"
                                else
                                        for num in [0...json.length]
                                                if trainList[json[num].name]?
                                                        msg.send "#{json[num].company} #{json[num].name} が遅れています"
                                                        delayedInList +=1
                                        if delayedInList is 0
                                                msg.send "#{d.getHours()}時#{d.getMinutes()}分現在，ご指定の列車に，遅延はありません"

                        else  # APIレスポンスエラー
                                msg.send "Response error: #{response.statusCode}"
                                return

