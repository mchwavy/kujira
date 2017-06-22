# Description
#   A Hubot script that tells todo list on trello
#
# Dependencies:
# 
# Configuration:
#   None
#
# Commands:
# やること ○○ - ○○をやることリストに加える
# やることリスト - やることリストを見る
# やっていることリスト - やっていることリストを見る
#
# Notes:
# 
# Author:
#   mchwavy
# 

Trello = require("node-trello")
exports = this

module.exports = (robot) ->
        robot.hear /^やること(\s+)(.*)/i, (msg) ->

                title="#{msg.match[2]}"
                tobuyList=title.split(/\s/)
                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                for num in [0...tobuyList.length]

                        exports.stuff=tobuyList[num]

                        trello.post "/1/lists/#{process.env.HUBOT_TRELLO_TODO}/cards", {
                                name: tobuyList[num]
                                due: null 
                        }, (err, data) ->

                                if err
                                        msg.send "保存に失敗しました"
                                        return

                                msg.send "#{exports.stuff}をTrelloのやることリストに保存しました。"


        robot.hear /^やることリスト(\s?)$/i, (msg) ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_TODO}/cards", {
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
                                msg.send "やることリストは空です。"
                                return
                                
                        listMessage="やることリストです\n"
                        for num in [0...json.length]
                                # msg.send "list id: #{json[num].id}"
                                listMessage+="#{json[num].name}"
                                if num < json.length-1
                                        listMessage +="、"

                        msg.send "#{listMessage}"

        robot.hear /^やっていることリスト(\s?)$/i, (msg) ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_DOING}/cards", {
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
                                msg.send "やっていることリストは空です。"
                                return
                                
                        listMessage="やっていることリストです\n"
                        for num in [0...json.length]
                                # msg.send "list id: #{json[num].id}"
                                listMessage+="#{json[num].name}"
                                if num < json.length-1
                                        listMessage +="、"

                        msg.send "#{listMessage}"

        robot.hear /^やることリスト(\s*)ID$/i, (msg) ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_TODO}/cards", {
                }, (err, data) ->

                        if err
                                msg.send "リスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                msg.send "JSON parse error: #{e}"

                        listMessage="やることリストです\n"
                        for num in [0...json.length]
                                listMessage+="#{json[num].id}: #{json[num].name}"
                                if num < json.length-1
                                        listMessage +="\n"

                        msg.send "#{listMessage}"

        robot.hear /^やっていることリスト(\s*)ID$/i, (msg) ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_DOING}/cards", {
                }, (err, data) ->

                        if err
                                msg.send "リスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                msg.send "JSON parse error: #{e}"

                        listMessage="やっていることリストです\n"
                        for num in [0...json.length]
                                listMessage+="#{json[num].id}: #{json[num].name}"
                                if num < json.length-1
                                        listMessage +="\n"

                        msg.send "#{listMessage}"


        # 定期処理をするオブジェクトを宣言
        cronJob = require('cron').CronJob

        # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
        send = (channel, msg) ->
                robot.send {room: channel}, msg

        # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
        # #your_channelと言う部屋に、平日の18:30時に実行
        new cronJob('0 30 17 * * *', () ->
                # ↑のほうで宣言しているsendメソッドを実行する
                send '#michio_work', "@michio やることリストに加えるものはありませんか?\n もしあれば、「やること ○○」と言って下さい。"
        ).start()

        new cronJob('0 0 9 * * *', () ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_TODO}/cards", {
                }, (err, data) ->

                        if err
                                send '#michio_work', "やることリスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                send '#michio_work', "JSON parse error: #{e}"

                        if json.length is 0
                                send '#michio_work', "やることリストは空です。"
                                return

                        listMessage="@michio やることリストを送ります。\n"
                        for num in [0...json.length]
                                # msg.send "list id: #{json[num].id}"
                                listMessage+="#{json[num].name}"
                                if num < json.length-1
                                        listMessage +="，"

                        listMessage+="\n 早めに取りかかりましょう。"

                        send '#michio_work', "#{listMessage}"

                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_DOING}/cards", {
                }, (err, data) ->

                        if err
                                send '#michio_work', "やっていることリスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                send '#michio_work', "JSON parse error: #{e}"

                        if json.length is 0
                                send '#michio_work', "やっていることリストは空です。"
                                return

                        listMessage="@michio やっていることリストを送ります。\n"
                        for num in [0...json.length]
                                # msg.send "list id: #{json[num].id}"
                                listMessage+="#{json[num].name}"
                                if num < json.length-1
                                        listMessage +="，"

                        listMessage+="\n 早めにやってしまいましょう。"
                        listMessage+="\n #{process.env.HUBOT_TRELLO_WORK_URL}"

                        send '#michio_work', "#{listMessage}"

                # ↑のほうで宣言しているsendメソッドを実行する
                # send '#kujira_channel', "@michio 買い物リストに加えるものはありませんか?\n もしあれば，「買い物 ○○」と言って下さい．"
        ).start()
