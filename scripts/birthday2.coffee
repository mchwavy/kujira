cronJob = require('cron').CronJob

module.export = (robot) ->

        bdSay = (slackname, name, month, day) ->
                month2=Number(month)-1
                # cronTime="0 46 11 #{day} #{month2} *"
                cronTime="0 52 11 * * *"
                task1 = new cronJob(cronTime, () ->
                        envelope = room: "random"
                        robot.send envelope, "Test"
                        # say = """
                        # ```
                        # #{month} #{day}だよ #{name}
                        # '''
                        # """
                        # robot.send envelope, say
                        # , null, true
                )

        bdSay('test', 'test', 5, 23)
                
