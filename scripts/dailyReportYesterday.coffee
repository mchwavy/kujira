# Description
# A Hubot script that makes daily report of yesterday on Evernote 
#
# Dependencies:
#        hubot-slack-api
#        mailgun
# Configuration:
#  None
#
# Commands:
#  昨日の日報を作って 昨日の日報を作ります 
#
# Notes:
# I don't know how to use hubot-slack-api...
# 
# Author:
#  mchwavy

mailgun_api_key = process.env.HUBOT_MAILGUN_API
mailgun_domain  = process.env.HUBOT_MAILGUN_DOMAIN
mailgun = require('mailgun-js')({apiKey: mailgun_api_key, domain: mailgun_domain})

message_from = process.env.HUBOT_MAIL_FROM
message_to   = process.env.HUBOT_MAIL_EVERNOTE_TO
message_title = 'test'

pad = (num, width) ->
        num += ""
        while num.length < width
                num = "0" + num
        num
        
sendmail = (msg, mailSubject, listMessage) ->
        message_text = listMessage

        mailgun.messages().send(
                from: message_from
                to:   message_to
                subject: mailSubject
                text: message_text
                (error, body) ->
                        # console.log '--------------------'
                        # console.log message_from, message_to
                        # console.log(body)
                        msg.send "Evernoteに送りました。"
        )

module.exports = (robot) ->
        robot.hear /^昨日の日報を作って/, (msg) ->

                # msg.send "タイムスタンプを設定します"

                # command = "date -d `date +%F` +%s"
                command = "echo `date -d \\`date +%F\\` +%s`,`date +%s`"
                @exec = require('child_process').exec

                # msg.send "Command: #{command}"

                dNow = new Date
                tsNow = Math.round(dNow.getTime()*1e-3)

                year = dNow.getFullYear()
                month = dNow.getMonth() + 1
                date = dNow.getDate()

                midnightTime="#{year}-#{month}-#{date} 0:0:0.000"
                dMidnight = new Date(midnightTime)

                tsMidnight = Math.round(dMidnight.getTime()*1e-3)
                tsYDMidnight = tsMidnight - 86400
                # msg.send "tsNow: #{tsNow}, tsMidnight: #{tsMidnight}"

                dYD = new Date
                dYD.setTime(dYD.getTime() - 86400 * 1000)
                year = dYD.getFullYear()
                month = dYD.getMonth() + 1
                date = dYD.getDate()

                mailSubject="#{year}-#{pad month, 2}-#{pad date, 2} @0201_Logbook"

                apiUrl="https://slack.com/api/conversations.history?token=#{process.env.HUBOT_SLACK_TOKEN}&channel=#{process.env.HUBOT_SLACK_WORK_CHANNEL}&oldest=#{tsYDMidnight}&latest=#{tsMidnight}&pretty=1"

                msg.send "昨日の日報を作成します"
                # msg.send "#{apiUrl}"

                request = require "request"

                # URLにアクセスしてデータを取得する
                request apiUrl, (err, response, body) ->
                # request.get "#{apiUrl}", (err, response, body) ->

                        if err  # プログラムエラー
                                msg.send "データ取得に失敗しました"
                                return

                        if response.statusCode is 200  # 取得成功
                                # JSONとして解釈する
                                try
                                        json = JSON.parse(body)
                                catch e
                                        msg.send "JSON parse error: #{e}"

                        # msg.send "#{json.ok}"

                        listMessage=""
                        for num in [json.messages.length-1..0]
                                if json.messages[num].user is process.env.HUBOT_SLACK_MYIDNUM
                                        listMessage+="#{json.messages[num].text}\n \n"

                                if json.messages[num].username is "kuma the timekeeper"
                                        listMessage+="#{json.messages[num].text}\n \n"
                                                                                
                        # msg.send "#{listMessage}"

                        sendmail(msg, mailSubject, listMessage)

