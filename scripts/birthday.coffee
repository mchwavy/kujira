# Description
# A Hubot script that tells your party members' birthday
#
# Dependencies:
#
# Configuration:
#  None
#
# Commands:
#  hubot when is @user birthday - to know the bday of a person
#  hubot show bdays - to get full list of user birthdays
#  hubot show next bdays - lists upcoming birthdays
#
# Notes:
#
# Author:
#  mchwavy

# 定期処理をするオブジェクトを宣言
cronJob = require('cron').CronJob

module.exports = (robot) ->

        bdlist =
                michio : "11-25"
                misaki : "09-09"
                
        # 特定のチャンネルへ送信するメソッド
        send = (channel, msg) ->
                robot.send {room: channel}, msg

        # Test for cronJob and send
        # new cronJob('0 11 14 * * *', () ->
        #         # ↑のほうで宣言しているsendメソッドを実行する
        #         send '#general', "@user Test"
        # ).start()
                              # 
        bdSay = (slackname, month, day) ->
                month2=Number(month)-1
                cronTime="0 00 08 #{day} #{month2} *"
                task1=new cronJob(cronTime, () ->
                        # envelope = room: "random"
                        # robot.send envelope, "Test"
                        say = """
                        ```
                        (^o^)/~~
                        #{month} 月 #{day} 日は，#{slackname} の誕生日だよ!
                        ```
                        Happy Birthday @#{slackname}!
                        """
                        send '#general', say
                        # robot.send envelope, say
                        # , null, true
                ).start()

        for slackname, bday of bdlist
                bdaySplit = bday.split "-"
                month = parseInt bdaySplit[0]
                day = parseInt bdaySplit[1]
                bdSay(slackname, month, day)

        robot.respond /when is @(.*) birthday/, (msg) ->
                askedUser = msg.match[1]
                # msg.send askedUser

                for slackname, bday of bdlist
                        if askedUser is slackname
                                bdaySplit = bday.split "-"
                                month = parseInt bdaySplit[0]
                                day = parseInt bdaySplit[1]
                                msg.send "#{slackname}の誕生日は #{month} 月 #{day} 日です"
                        else
                                msg.send "#{slackname}の誕生日はわかりません"


        robot.respond /show bdays/, (msg) ->
                for slackname, bday of bdlist
                        bdaySplit = bday.split "-"
                        month = parseInt bdaySplit[0]
                        day = parseInt bdaySplit[1]
                        msg.send "#{slackname}の誕生日は #{month} 月 #{day} 日です"

        robot.respond /show next bdays/, (msg) ->
                d = new Date
                nowyear = d.getFullYear()
                nowmonth = d.getMonth() + 1
                nowdate = d.getDate()
                
                for slackname, bday of bdlist
                        bdaySplit = bday.split "-"
                        month = parseInt bdaySplit[0]
                        day = parseInt bdaySplit[1]

                        if nowmonth > month or (nowmonth == month and nowdate > date)
                                nextbdyear = nowyear + 1
                        else
                                nextbdyear = nowyear
                        nextbdmonth = month
                        nextbddate = day
                        
                        nextbdyear += ""
                        nextbdmonth += ""
                        nextbddate += ""
                        nextbd = nextbdyear + "-" + nextbdmonth + "-" + nextbddate + " 12:00:00 +0900"
                        nextbd = new Date nextbd
                        diffMs = nextbd.getTime() - d.getTime()
                        days = parseInt(diffMs / (24*60*60*1000), 10)

                        msg.send "#{slackname}の誕生日は #{month} 月 #{day} 日で，あと #{days} 日です"

