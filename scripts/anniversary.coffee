# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob

module.exports = (robot) ->

        # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
        send = (channel, msg) ->
                robot.send {room: channel}, msg

        # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
        # generalと言う部屋に、月木の16:10時に実行
        new cronJob('0 30 7 13 3 *', () ->
                # ↑のほうで宣言しているsendメソッドを実行する
                send '#general', "今日は結婚式を挙げた日です。"
        ).start()

        new cronJob('0 30 7 9 8 *', () ->
                # ↑のほうで宣言しているsendメソッドを実行する
                send '#general', "今日は入籍した日です。"
        ).start()

        new cronJob('0 30 7 9 6 *', () ->
                # ↑のほうで宣言しているsendメソッドを実行する
                send '#general', "今日は付き合いはじめた日かもしれません。"
        ).start()




