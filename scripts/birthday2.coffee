cronJob = require('cron').CronJob

module.export = (robot) ->

        bdSay = (slackname, name, month, day) ->
                month2=Number(month)-1
                cronTime="0 14 11 #{day} #{month2} *"
                task1 = new cronJob(cronTime, () ->
                envelope = room: "random"
                say = """
                ```
                #{month} #{day}だよ #{name}
                '''
                """
                robot.send envelope, "test"
                )

        bdSay('test', 'test', 5, 23)
                
