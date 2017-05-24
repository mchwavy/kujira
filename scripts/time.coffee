# Description
#   A Hubot script that returns present time
#   Modified from the original script in http://kyu-mu.net/coffeescript/howto/2.html
#
# Configuration:
#   None
#
# Commands:
#   hubot 今何時 - returns present time
#
# Author
#   mchwavy

module.exports = (robot) ->
        robot.respond /今何時/, (msg) ->
                d = new Date
                msg.send "#{d.getHours()}時#{d.getMinutes()}分だよ"

                
