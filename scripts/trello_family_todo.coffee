# Description
#   A Hubot script that tells todo lists
#
# Dependencies:
# 
# Configuration:
#   None
#
# Commands:
# 家事やって ○○ - ○○を家事リストに加える
# 家事リスト - 家事リストを見る
# 家事リスト ID - 家事リストにあるそれぞれのカードのIDを見る
# 家事やった ○○ - ○○を家事リストから消す
#
# Notes:
# 
# Author:
#   mchwavy
# 

Trello = require("node-trello")
exports = this

module.exports = (robot) ->
        robot.hear /^家事やって(\s+)(.*)/i, (msg) ->

                title="#{msg.match[2]}"
                tobuyList=title.split(/\s/)
                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                for num in [0...tobuyList.length]

                        exports.stuff=tobuyList[num]

                        trello.post "/1/lists/#{process.env.HUBOT_TRELLO_FAMILY_TODO}/cards", {
                                name: tobuyList[num]
                                due: null 
                        }, (err, data) ->

                                if err
                                        msg.send "保存に失敗しました"
                                        return

                                msg.send "#{exports.stuff}をTrelloの家事リストに保存しました。"
                        

        robot.hear /^家事リスト(\s?)$/i, (msg) ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_FAMILY_TODO}/cards", {
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
                                msg.send "家事リストは空です。"
                                return
                                
                        listMessage="家事リストです\n"
                        for num in [0...json.length]
                                # msg.send "list id: #{json[num].id}"
                                listMessage+="#{json[num].name}"
                                if num < json.length-1
                                        listMessage +="、"

                        msg.send "#{listMessage}"

        robot.hear /^家事リスト(\s*)ID$/i, (msg) ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_FAMILY_TODO}/cards", {
                }, (err, data) ->

                        if err
                                msg.send "リスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                msg.send "JSON parse error: #{e}"

                        listMessage="家事リストです\n"
                        for num in [0...json.length]
                                listMessage+="#{json[num].id}: #{json[num].name}"
                                if num < json.length-1
                                        listMessage +="\n"

                        msg.send "#{listMessage}"

        robot.hear /^家事やった(\s+)(.*)/i, (msg) ->

                title="#{msg.match[2]}"

                tobuyList=title.split(/\s/)
                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_FAMILY_TODO}/cards", {
                }, (err, data) ->

                        if err
                                msg.send "リスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                msg.send "JSON parse error: #{e}"

                        # msg.send "length: #{tobuyList.length} \n"

                        for num in [0...json.length]
                                # msg.send "#{json[num].name} #{title]}"
                                if json[num].name is title
                                        # msg.send "家事リストから#{title}を消します"
                                        # msg.send "#{title}のIDは: #{json[num].id}"

                                        trello.put "/1/cards/#{json[num].id}/closed", {
                                                value: true
                                        }, (err, data) ->
        
                                                if err
                                                        msg.send "消すのに失敗しました"
                                                        return
                                
                                                msg.send "Trelloの家事リストにある「#{title}」を消しました"
                                                return

                        # msg.send "家事リストに#{title}はありません"


        # 定期処理をするオブジェクトを宣言
        cronJob = require('cron').CronJob

        # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
        send = (channel, msg) ->
                robot.send {room: channel}, msg

        # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
        # #your_channelと言う部屋に、平日の18:30時に実行
        # new cronJob('0 30 17 * * 5', () ->
        #         # ↑のほうで宣言しているsendメソッドを実行する
        #         send '#general', "@michio @misaki 家事リストに加えるものはありませんか?\n もしあれば、「家事 ○○」と言って情報を共有しましょう。"
        # ).start()

        new cronJob('0 30 17 * * *', () ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_FAMILY_TODO}/cards", {
                }, (err, data) ->

                        if err
                                send '#general', "家事リスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                send '#general', "JSON parse error: #{e}"

                        if json.length is 0
                                send '#general', "家事リストは空です。"
                                return

                        listMessage="@michio @misaki 家事リストを送ります。\n"
                        for num in [0...json.length]
                                # msg.send "list id: #{json[num].id}"
                                listMessage+="#{json[num].name}"
                                if num < json.length-1
                                        listMessage +="，"

                        listMessage+="\n 家事リストに加えるときは、「家事やって ○○」と言って下さい。"
                        listMessage+="\n 家事をやったら、「家事やった ○○」と言って下さい。"

                        send '#general', "#{listMessage}"

                # ↑のほうで宣言しているsendメソッドを実行する
                # send '#kujira_channel', "@michio 買い物リストに加えるものはありませんか?\n もしあれば，「買い物 ○○」と言って下さい．"
        ).start()
