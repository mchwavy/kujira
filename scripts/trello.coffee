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
exports = this

module.exports = (robot) ->
        robot.hear /^買い物(\s+)(.*)/i, (msg) ->

                title="#{msg.match[2]}"
                tobuyList=title.split(/\s/)
                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                for num in [0...tobuyList.length]

                        exports.stuff=tobuyList[num]

                        trello.post "/1/lists/#{process.env.HUBOT_TRELLO_TOBUY}/cards", {
                                name: tobuyList[num]
                                due: null 
                        }, (err, data) ->

                                if err
                                        msg.send "保存に失敗しました"
                                        return

                                msg.send "#{exports.stuff}をTrelloの買い物リストに保存しました。"

        robot.hear /^(.*)(を|\s+)(買う|買って)$/i, (msg) ->

                title="#{msg.match[1]}"
                tobuyList=title.split(/\s/)
                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                for num in [0...tobuyList.length]

                        exports.stuff=tobuyList[num]

                        trello.post "/1/lists/#{process.env.HUBOT_TRELLO_TOBUY}/cards", {
                                name: tobuyList[num]
                                due: null 
                        }, (err, data) ->

                                if err
                                        msg.send "保存に失敗しました"
                                        return

                                msg.send "#{exports.stuff}をTrelloの買い物リストに保存しました。"


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
                                msg.send "買い物リストは空です。"
                                return
                                
                        listMessage="買い物リストです\n"
                        for num in [0...json.length]
                                # msg.send "list id: #{json[num].id}"
                                listMessage+="#{json[num].name}"
                                if num < json.length-1
                                        listMessage +="、"

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

        robot.hear /^買った(\s*)(.*)$/i, (msg) ->

                # title="#{msg.match[2]}"
                # tobuyList=title.split(/\s/)
                # trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                # for num in [0...tobuyList.length]

                #         exports.stuff=tobuyList[num]

                title="#{msg.match[2]}"
                tobuyList=title.split(/\s/)
                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                for lnum in [0...tobuyList.length]

                        exports.stuff=tobuyList[lnum]

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

                        # msg.send "length: #{tobuyList.length} \n"


                                for num in [0...json.length]
                                # msg.send "#{json[num].name} #{title]}"
                                        if json[num].name is exports.stuff
                                        # msg.send "買い物リストから#{title}を消します"
                                        # msg.send "#{title}のIDは: #{json[num].id}"

                                                trello.put "/1/cards/#{json[num].id}/closed", {
                                                        value: true
                                                }, (err, data) ->
        
                                                        if err
                                                                msg.send "消すのに失敗しました"
                                                                return
                                
#                                                        msg.send "Trelloの買い物リストにある「#{title}」を消しました"
                                                        msg.send "Trelloの買い物リストにある「#{exports.stuff}」を消しました"
                                                        return

                        # msg.send "買い物リストに#{title}はありません"

        robot.hear /^(.*)(を|(\s+))買った$/i, (msg) ->

                title="#{msg.match[1]}"

                tobuyList=title.split(/\s/)
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

                        # msg.send "length: #{tobuyList.length} \n"

                        for num in [0...json.length]
                                # msg.send "#{json[num].name} #{title]}"
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

                        # msg.send "買い物リストに#{title}はありません"



        # 定期処理をするオブジェクトを宣言
        cronJob = require('cron').CronJob

        # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
        send = (channel, msg) ->
                robot.send {room: channel}, msg

        # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
        # #your_channelと言う部屋に、平日の18:30時に実行
        new cronJob('0 0 12 * * *', () ->
                # ↑のほうで宣言しているsendメソッドを実行する
                send '#general', "@michio @misaki 買い物リストに加えるものはありませんか?\n もしあれば、「買い物 ○○」と言って情報を共有しましょう。"
        ).start()

        new cronJob('0 0 16 * * *', () ->

                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

                trello.get "/1/lists/#{process.env.HUBOT_TRELLO_TOBUY}/cards", {
                }, (err, data) ->

                        if err
                                send '#general', "買い物リスト取得に失敗しました"
                                return

                        jdata=JSON.stringify(data)
                        try
                                json=JSON.parse(jdata)
                        catch e
                                send '#general', "JSON parse error: #{e}"

                        if json.length is 0
                                send '#general', "買い物リストは空です。"
                                return

                        listMessage="@michio @misaki 買い物リストを送ります。\n"
                        for num in [0...json.length]
                                # msg.send "list id: #{json[num].id}"
                                listMessage+="#{json[num].name}"
                                if num < json.length-1
                                        listMessage +="，"

                        listMessage+="\n 買い終わったら、「買った ○○」と言って下さい。"

                        send '#general', "#{listMessage}"

                # ↑のほうで宣言しているsendメソッドを実行する
                # send '#kujira_channel', "@michio 買い物リストに加えるものはありませんか?\n もしあれば，「買い物 ○○」と言って下さい．"
        ).start()
