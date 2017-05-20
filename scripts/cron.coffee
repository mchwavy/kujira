cron = require('cron').CronJob

module.exports = (robot) ->
     new cron '0 59 11 * * *', () =>
     robot.send {room: "#random"}, "Test cron", null, true, "Asia/Tokyo"
