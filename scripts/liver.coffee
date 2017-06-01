# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob

module.exports = (robot) ->

        # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
        send = (channel, msg) ->
                robot.send {room: channel}, msg


        # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
        # generalと言う部屋に、月木の16:10時に実行
        new cronJob('0 10 16 * * 1,4', () ->
                # ↑のほうで宣言しているsendメソッドを実行する
                send '#general', "@michio 今日は休肝日です．"
        ).start()




