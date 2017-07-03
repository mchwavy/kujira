api_key = process.env.HUBOT_MAILGUN_API
domain = process.env.HUBOT_MAILGUN_DOMAIN
#mailgun = require('mailgun-js')({apiKey: api_key, domain: domain})
# mailgun = require('mailgun-js')({ apiKey:api_key, domain })

message_from = process.env.HUBOT_MAIL_FROM
message_to = process.env.HUBOT_MAIL_TO
message_title = 'test'

sendmail = () ->
        message_text = "This is a test"

#         mailgun.messages().send(
#                 from: message_from
#                 to: message_to
#                 subject: message_title
#                 text: message_text
#                 (error, body) ->
#                         console.log '--------------------'
#                         console.log message_from, message_to
#                         console.log(body)
#         )

module.exports = (robot) ->
        robot.hear /^sendmail/, (msg) ->
                sendmail()
