# Description
#   A Hubot script that returns an oden
#
# Configuration:
#   None
#
# Commands:
#   hubot おでん - returns an oden
#
# Author:
#   bouzuya <m@bouzuya.net>

module.exports = (robot) ->
  robot.respond /おでん/, (msg) ->
    msg.send '─□○△'
