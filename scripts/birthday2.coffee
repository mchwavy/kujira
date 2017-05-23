# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob

#

module.exports = (robot) ->

        # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
        send = (channel, msg) ->
                robot.send {room: channel}, msg

        # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
        # #your_channelと言う部屋に、平日の18:30時に実行
        new cronJob('0 02 14 * * *', () ->
        # ↑のほうで宣言しているsendメソッドを実行する
                send '#general', "@michio Test1"
        ).start()

  # #your_channelと言う部屋に、平日の13:00時に実行
        new cronJob('0 03 14 * * *', () ->
                send '#general', "@michio Test2"
        ).start()

#

        # send '#general', "@michio Test-B2-A"

        new cronJob('0 04 14 * * *', () ->
                # ↑のほうで宣言しているsendメソッドを実行する
                send '#general', "@michio Test-B2-B"
        ).start()
                              # 
        # bdSay = (slackname, name, month, day) ->
        #         month2=Number(month)-1
        #         # cronTime="0 46 11 #{day} #{month2} *"
        #         cronTime="0 10 13 * * *"
        #         task1=new cronJob(cronTime, () ->
        #                 send '#random', "@michio Test-B2-C"
        #                 envelope = room: "random"
        #                 robot.send envelope, "Test"
        #                 # say = """
        #                 # ```
        #                 # #{month} #{day}だよ #{name}
        #                 # '''
        #                 # """
        #                 # robot.send envelope, say
        #                 # , null, true
        #         ).start()

        # bdSay('test', 'test', 5, 23)

        # send '#general', "@michio Test-B2-D"
                
