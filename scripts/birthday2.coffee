# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob

module.exports = (robot) ->

        bdlist =
                michio : "05-23"

        # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
        send = (channel, msg) ->
                robot.send {room: channel}, msg

        # Test for cronJob and send
        # new cronJob('0 11 14 * * *', () ->
        #         # ↑のほうで宣言しているsendメソッドを実行する
        #         send '#general', "@michio Test-B2-B"
        # ).start()
                              # 
        bdSay = (slackname, month, day) ->
                month2=Number(month)-1
                cronTime="0 16 15 #{day} #{month2} *"
                task1=new cronJob(cronTime, () ->
                        # envelope = room: "random"
                        # robot.send envelope, "Test"
                        say = """
                        ```
                        \(^o^)/
                        #{month} 月 #{day} 日だよ #{slackname}!
                        ```
                        Hi! @#{slackname}
                        """
                        send '#general', say
                        # robot.send envelope, say
                        # , null, true
                ).start()

        for slackname, bday of bdlist
                arrayt = bday.split "-"
                month = parseInt arrayt[0]
                day = parseInt arrayt[1]
                bdSay(#{slackname}, month, day)

        # send '#general', "@michio Test-B2-D"
                
