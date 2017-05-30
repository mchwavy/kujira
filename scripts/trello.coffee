Trello = require("node-trello")

module.exports = (robot) ->
        robot.respond /買い物(\s?)(.*)/i, (msg) ->
                title="#{msg.match[2]"
                trello = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)
                trello.post "/1/cards", {
                        name: title
                        desc: "ToBuy"
                        idList: process.env.HUBOT_TRELLO_TOBUY
                }, (err, data) ->

                        if err
                                msg.send "保存に失敗しました"
                                return
                        msg.send "「#{title}」 をTrelloの買い物ボードに保存しました"
                        
