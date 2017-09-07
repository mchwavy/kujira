# Description
# Send a message to Line Room.
#
# Dependencies:
#
# Configuration:
#  None
#
# Commands:
#  ライン ○○ Lineにメッセージを送る。
#  Line ○○ Lineにメッセージを送る。
#  Ｌｉｎｅ ○○ Lineにメッセージを送る。
#
# Notes:
# 
# Author:
#  mchwavy

message_token = process.env.HUBOT_LINE_NOTIFY_API_TOKEN
child_process = require 'child_process'

sendmsg = (msg, listMessage) ->
        message_text = listMessage

        child_process.exec "curl -X POST -H 'Authorization: Bearer #{message_token}' -F 'message=#{message_text}' https://notify-api.line.me/api/notify", (error, stdout, stderr) ->
                if !error
                        output = stdout+''
                        msg.send "#{output}"
                else
                        msg.send "error"

module.exports = (robot) ->
        robot.hear /^(ライン|Line|line|Ｌｉｎｅ|ｌｉｎｅ)(\s+)(.*)/i, (msg) ->

                body="#{msg.match[3]}"

                # msg.send "Command: #{command}"
                # msg.send ""

                listMessage=body

                sendmsg(msg, listMessage)

