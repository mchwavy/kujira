# Description
#   A Hubot script that search for recipe
#
# Configuration:
#   None
#
# Commands:
#   hubot 料理 ○○- ○○を使った料理を調べます。
#
# Author:
#   mchwavy

module.exports = (robot) ->
        robot.respond /料理\s(.*)/, (msg) ->
                text="quugle.blogspot.jp/search?q="
                things=msg.match[1]
                lists=things.split /\s+/
                for num in [0...lists.length]
                        text+=lists[num]
                        if num < lists.length-1
                                text+="+"

                msg.send text
