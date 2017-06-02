# Description
#   A Hubot script that calles google form 
#
# Configuration:
#   None
#
# Commands:
#   家計簿 - 支出の登録を始めます
#
# Author:
#   mchwavy

module.exports = (robot) ->
        robot.hear /^家計簿$/, (msg) ->
                text="https://goo.gl/forms/"
                text+="#{process.env.HUBOT_GOOGLE_FORM_EXPENSE}"

                msg.send text
