# Description
# A Hubot script that tells your party members' birthday
#
# Dependencies:
#        hubot-slack-api
#        mailgun
# Configuration:
#  None
#
# Commands:
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
message_to   = process.env.HUBOT_MAIL_TO_CELLU1
message_title = 'test'

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
                        msg.send "ケータイに送りました。"
        )

module.exports = (robot) ->
        robot.hear /^ケータイ(\s+)(.*)/i, (msg) ->

                body="#{msg.match[2]}"
                # msg.send "Command: #{command}"

                mailSubject="kujira からメールです"

                # msg.send "日報を作成します"
                # msg.send "#{apiUrl}"
                msg.send "#{body}"

                listMessage=body

                sendmail(msg, mailSubject, listMessage)

