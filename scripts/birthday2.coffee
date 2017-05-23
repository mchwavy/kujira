cronJob = require('cron').CronJob

module.export = (robot) ->

        # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
        send = (channel, msg) ->
                robot.send {room: channel}, msg
                
        bdSay = (slackname, name, month, day) ->
                month2=Number(month)-1
                # cronTime="0 46 11 #{day} #{month2} *"
                cronTime="0 34 12 * * *"
                task1=new cronJob(cronTime, () ->
                        send '#random', "@michio test"
                        envelope = room: "random"
                        robot.send envelope, "Test"
                        # say = """
                        # ```
                        # #{month} #{day}だよ #{name}
                        # '''
                        # """
                        # robot.send envelope, say
                        # , null, true
                ).start()

        bdSay('test', 'test', 5, 23)
        send '#general', "@michio testA"
                
