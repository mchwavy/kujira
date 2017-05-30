# Description
#   A Hubot script that tells bus time
# 
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#  hubot 平日の池袋行きバス - 平日の池袋行きバス
#  hubot 土曜の池袋行きバス - 土曜の池袋行きバス
#  hubot 日曜の池袋行きバス - 日曜の池袋行きバス
#  hubot 池袋行きバス - 池袋行きバス直近4本の時間
#
# Notes:
#
# Author:
#   mchwavy

busListWeekday = [ 638,
        705, 722, 745,
        802, 829, 844,
        906, 930, 948,
        1009, 1030, 1056,
        1119, 1144,
        1210, 1236,
        1300, 1324, 1349,
        1415, 1437, 1454,
        1513, 1533, 1554,
        1633,
        1713, 1751, 
        1823, 1855,
        1928,
        2000, 2030 ]

busListWeekday40 = [ 611, 615,620, 622, 629, 634, 636, 644, 654
        702, 707, 715, 723,
        1118, 1154,
        1235, 1241,
        1345,
        1513, 1527, 1543,
        1638,
        1738, 1752,
        1910, 1920,
        2012  ]

busListSaturday = [ 651,
        729, 746,
        814, 833, 853,
        913, 933, 952,
        1013, 1032, 1052,
        1112, 1132, 1156,
        1211, 1228, 1246,
        1304, 1322, 1342,
        1403, 1424, 1443,
        1504, 1525, 1545,
        1605, 1625, 1645,
        1708, 1726, 1757,
        1819, 1841,
        1906, 1924, 1953,
        2031 ]

busListSaturday40 = [ 613, 615, 621, 622, 628, 635, 638, 646, 659,
        710, 745,
        801, 837, 856,
        918, 930
        1014, 1026, 1050,
        1108, 1126, 1142, 1151,
        1230,
        1323,
        1405, 1435,
        1533,
        1649,
        1828 ]

busListSunday = [ 651,
        737,
        832,
        902, 917, 938, 958
        1018, 1038, 1058,
        1118, 1139, 1158,
        1211, 1226, 1240, 1255,
        1310, 1325, 1341, 1357,
        1414, 1430, 1445,
        1502, 1517, 1534, 1552,
        1610, 1629, 1647,
        1708, 1730, 1750,
        1812, 1840,
        1909, 1932,
        2000, 2032 ]

busListSunday40 = [ 613, 615, 623, 624, 631, 633,
        837, 846,
        905, 959,
        1039, 1059,
        1104, 1155,
        1205, 1211,
        1326, 1333,
        1410, 1427, 1459,
        1506, 1524,
        1824,
        1944 ]
        
for num in [0...busListWeekday40.length]
        busListWeekday.push busListWeekday40[num]
busListWeekday.sort (a,b) -> a - b

for num in [0...busListSaturday40.length]
        busListSaturday.push busListSaturday40[num]
busListSaturday.sort (a,b) -> a - b

for num in [0...busListSunday40.length]
        busListSunday.push busListSunday40[num]
busListSunday.sort (a,b) -> a - b

module.exports = (robot) ->
        robot.respond /平日の池袋行きバス/, (msg) ->

                d = new Date
                # msg.send busListWeekday.length

                busFromNow = ""                
                for num in [0...busListWeekday.length]
                        busFromNow += "、"
                        busTimeStrInFour = busListWeekday[num] + ""
                        if busListWeekday[num] < 1000
                                busTimeStr = busTimeStrInFour[0]+":"+busTimeStrInFour[1..2]
                        else
                                busTimeStr = busTimeStrInFour[0..1]+":"+busTimeStrInFour[2..3]

                        busFromNow += busTimeStr

                msg.send "平日の池袋行きバスは#{busFromNow}"


        robot.respond /土曜の池袋行きバス/, (msg) ->

                d = new Date
                # msg.send busListSaturday.length
                
                busFromNow = ""                
                for num in [0...busListSaturday.length]
                        busFromNow += "、"
                        busTimeStrInFour = busListSaturday[num] + ""
                        if busListSaturday[num] < 1000
                                busTimeStr = busTimeStrInFour[0]+":"+busTimeStrInFour[1..2]
                        else
                                busTimeStr = busTimeStrInFour[0..1]+":"+busTimeStrInFour[2..3]

                        busFromNow += busTimeStr

                msg.send "土曜の池袋行きバスは#{busFromNow}"

        robot.respond /(日曜|祝日)の池袋行きバス/, (msg) ->

                d = new Date
                # msg.send busListSunday.length
                
                busFromNow = ""                
                for num in [0...busListSunday.length]
                        busFromNow += "、"
                        busTimeStrInFour = busListSunday[num] + ""
                        if busListSunday[num] < 1000
                                busTimeStr = busTimeStrInFour[0]+":"+busTimeStrInFour[1..2]
                        else
                                busTimeStr = busTimeStrInFour[0..1]+":"+busTimeStrInFour[2..3]

                        busFromNow += busTimeStr

                msg.send "日曜祝日の池袋行きバスは#{busFromNow}"



        robot.respond /池袋行きバス/, (msg) ->

                # msg.send "電車の遅延状況を調べます…"
                d = new Date

                todayDay=d.getDay()     # 0:Sunday, 6:Saturday
                nowTime = d.getHours()*100 + d.getMinutes()

                todayYear = d.getFullYear() + ""
                todayMonth = "0" + (d.getMonth()+1)
                todayMonth = todayMonth[(todayMonth.length-2)..(todayMonth.length-1)]
                todayDate = "0" + d.getDate()
                todayDate = todayDate[(todayDay.length-2)..(todayDay.length-1)]
                todayFullDate = todayYear + "-" + todayMonth + "-" + todayDate
                todayDay = d.getDay()

                # Holiday

                dateTimeUrl = "https://holidays-jp.github.io/api/v1/" + todayYear + "/date.json"

                apiUrl = dateTimeUrl

                request = require "request"

                isHoliday = false

                # URLにアクセスしてデータを取得する
                request apiUrl, (err, response, body) ->
                # request.get "#{apiUrl}", (err, response, body) ->

                        if err
                                msg.send "データ取得に失敗しました"
                                return

                        if response.statusCode is 200  # 取得成功
                        # JSONとして解釈する
                                try
                                        json = JSON.parse(body)
                                catch e
                                        msg.send "JSON parse error: #{e}"


                                for key, value of json
                                        if todayFullDate is key
                                                isHoliday = true

                                # msg.send "#{todayFullDate} #{isHoliday}"
                                # str = "2017-01-01"
                                # for hdate, hname of json
                                #         msg.send "1月1日は休日です #{hdate} #{hname}"
                                # else
                                #         msg.send '変です#{hdate} #{hname}'
                                        

                        busFromNow = ""
                        icount = 0
                        # msg.send "#{todayFullDate} #{isHoliday}"

                        if (1 <= todayDay <=5) and (isHoliday is false) # 平日
                                for num in [0...busListWeekday.length]
                                        if nowTime < busListWeekday[num]

                                                busFromNow += "、"

                                                busTimeStrInFour = busListWeekday[num] + ""
                                                if busListWeekday[num] < 1000
                                                        busTimeStr = busTimeStrInFour[0]+":"+busTimeStrInFour[1..2]
                                                else
                                                        busTimeStr = busTimeStrInFour[0..1]+":"+busTimeStrInFour[2..3]
        
                                                busFromNow += busTimeStr

                                                icount += 1

                                                if icount is 4
                                                        break

                                if icount is 0
                                        busFromNow="終わりました"

                                msg.send "平日の池袋行きバスは#{busFromNow}"

                        else if (todayDay is 6) and (isHoliday is false) # 土曜
                                for num in [0...busListSaturday.length]
                                        if nowTime < busListSaturday[num]
                                                busFromNow += "、"

                                                busTimeStrInFour = busListSaturday[num] + ""
                                                if busListSaturday[num] < 1000
                                                        busTimeStr = busTimeStrInFour[0]+":"+busTimeStrInFour[1..2]
                                                else
                                                        busTimeStr = busTimeStrInFour[0..1]+":"+busTimeStrInFour[2..3]

                                                busFromNow += busTimeStr

                                                icount += 1

                                                if icount is 4
                                                        break

                                if icount is 0
                                        busFromNow="終わりました"

                                msg.send "土曜の池袋行きバスは#{busFromNow}"

                        else if (todayDay is 0) or (isHoliday is true) # 日曜 or 祝日
                                for num in [0...busListSunday.length]
                                        if nowTime < busListSunday[num]
                                                busFromNow += "、"

                                                busTimeStrInFour = busListSunday[num] + ""
                                                if busListSunday[num] < 1000
                                                        busTimeStr = busTimeStrInFour[0]+":"+busTimeStrInFour[1..2]
                                                else
                                                        busTimeStr = busTimeStrInFour[0..1]+":"+busTimeStrInFour[2..3]

                                                busFromNow += busTimeStr

                                                icount += 1

                                                if icount is 4
                                                        break

                                if icount is 0
                                        busFromNow="終わりました"

                                msg.send "日曜の池袋行きバスは#{busFromNow}"