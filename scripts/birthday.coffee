# 
# Description:
#   誕生日を祝うよ
#
# Commands:
#   
#
# 定期処理をするオブジェクトを宣言

cronJob = require('cron').CronJob


module.exports = (robot) ->

# 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
send = (channel, msg) ->
  robot.send {room: channel}, msg

# Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
# #your_channelと言う部屋に、平日の18:30時に実行
new cronJob('0 0 7 9 8 *', () ->
  # ↑のほうで宣言しているsendメソッドを実行する
  send '#general', "@misaki 今日は水咲さんの誕生日です。おめでとう！！！"
).start()

# #your_channelと言う部屋に、平日の13:00時に実行
new cronJob('0 0 7 25 10 *', () ->
  send '#general', "@michio 今日は路生さんの誕生日です。おめでとう！！！"
).start()


