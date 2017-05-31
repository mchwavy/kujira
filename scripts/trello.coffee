# Description
#   A Hubot script that tells bus time
#
# Dependencies:
# 
# Configuration:
#   None
#
# Commands:
# 買い物 ○○ - ○○を買い物リストに加える
# 買い物リスト - 買い物リストを見る
# 買い物リスト ID - 買い物リストにあるそれぞれのカードのIDを見る
# 買った ○○ - ○○を買い物リストから消す
#
# Notes:
# 
# Author:
#   mchwavy
# 

Trello = require("node-trello")

module.exports = (robot) ->
        robot.hear /^買い物(\s+)(.*)/i, (msg) ->

                title="#{msg.match[2]}"
                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
                trello.post "/1/lists/#{process.env.HUBOT_TRELLO_TOBUY}/cards", {
                        name: title
                        due: null 
                }, (err, data) ->

                        if err
                                msg.send "保存に失敗しました"
                                return
                        msg.send "「#{title}」 をTrelloの買い物リストに保存しました"
                        

        robot.hear /^買い物リスト(\s?)$/i, (msg) ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_TOBUY}/cards", {
                }, (err, data) ->

                        if err
                                msg.send "リスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                msg.send "JSON parse error: #{e}"

                        if json.length is 0
                                msg.send "買い物リストは空です．"
                                return
                                
                        listMessage="買い物リストです\n"
                        for num in [0...json.length]
                                # msg.send "list id: #{json[num].id}"
                                listMessage+="#{json[num].name}"
                                if num < json.length-1
                                        listMessage +="，"

                        msg.send "#{listMessage}"

        robot.hear /^買い物リスト(\s*)ID$/i, (msg) ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_TOBUY}/cards", {
                }, (err, data) ->

                        if err
                                msg.send "リスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                msg.send "JSON parse error: #{e}"

                        listMessage="買い物リストです\n"
                        for num in [0...json.length]
                                listMessage+="#{json[num].id}: #{json[num].name}"
                                if num < json.length-1
                                        listMessage +="\n"

                        msg.send "#{listMessage}"

        robot.hear /^買った(\s+)(.*)/i, (msg) ->

                title="#{msg.match[2]}"

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_TOBUY}/cards", {
                }, (err, data) ->

                        if err
                                msg.send "リスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                msg.send "JSON parse error: #{e}"

                        listMessage="買い物リストです\n"
                        for num in [0...json.length]

                                if json[num].name is title
                                        # msg.send "買い物リストから#{title}を消します"
                                        # msg.send "#{title}のIDは: #{json[num].id}"
                                        
                                        trello.put "/1/cards/#{json[num].id}/closed", {
                                                value: true
                                        }, (err, data) ->

                                        if err
                                                msg.send "消すのに失敗しました"
                                                return

                                        msg.send "Trelloの買い物リストにある「#{title}」を消しました"
                                        return

                        msg.send "買い物リストに#{title}はありません"


        # 定期処理をするオブジェクトを宣言
        cronJob = require('cron').CronJob

        # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
        send = (channel, msg) ->
                robot.send {room: channel}, msg

        # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
        # #your_channelと言う部屋に、平日の18:30時に実行
        new cronJob('0 0 12 * * *', () ->
                # ↑のほうで宣言しているsendメソッドを実行する
                send '#kujira_channel', "@michio 買い物リストに加えるものはありませんか?\n もしあれば，「買い物 ○○」と言って下さい．"
        ).start()

        new cronJob('0 20 11 * * *', () ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_TOBUY}/cards", {
                }, (err, data) ->

                        if err
                                send '#kujira_channel', "リスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                send '#kujira_channel', "JSON parse error: #{e}"

                        if json.length is 0
                                send '#kujira_channel', "買い物リストは空です．"
                                return

                        listMessage="買い物リストを送ります．\n"
                        for num in [0...json.length]
                                # msg.send "list id: #{json[num].id}"
                                listMessage+="#{json[num].name}"
                                if num < json.length-1
                                        listMessage +="，"

                        send '#kujira_channel', "#{listMessage}"

                # ↑のほうで宣言しているsendメソッドを実行する
                # send '#kujira_channel', "@michio 買い物リストに加えるものはありませんか?\n もしあれば，「買い物 ○○」と言って下さい．"
        ).start()
