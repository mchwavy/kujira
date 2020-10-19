# Description
#   A Hubot script that tells bus time
# 
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#  平日のバス - 平日の池袋行きバス
#  土曜のバス - 土曜の池袋行きバス
#  日曜のバス - 日曜の池袋行きバス
#  バス - 池袋行きバス直近4本の時間
#
# Notes:
#
# Author:
#   mchwavy

busListWeekday = [ 641,
        708, 724, 744,
        800, 813, 830, 851,
        910, 939, 958,
        1028, 1056,
        1119, 1141,
        1201, 1221, 1241,
        1303, 1323, 1344,
        1406, 1429, 1450,
        1511, 1530, 1554,
        1635,
        1714, 1751, 
        1821, 1851,
        1929,
        2001, 2031 ]

busListWeekday40 = [ 611, 620, 634,
        1149,
        1239,
	1433,
        1522, 1550,
        1604,
        1703, 1739, 1753,
	1817,
        1907, 1929, 1948 ]

busListSaturday = [ 654,
        734,
        801, 829, 848,
        908, 927, 946,
        1006, 1027, 1047,
        1108, 1126, 1147,
        1204, 1223, 1237, 1254,
        1312, 1329, 1348,
        1407, 1423, 1442,
        1500, 1517, 1535, 1552,
        1610, 1629, 1646,
        1705, 1724, 1759,
        1821, 1843, 1856,
        1926, 1952,
        2031 ]

busListSaturday40 = [ 613, 622, 636,
        750,
        845, 857,
        909, 956,
	1032,
        1108, 1137,
        1214, 1256,
        1319,
        1519,
        1620, 1647, 1654,
        1902, 1919 ]

busListSunday = [ 652,
        738,
        838,
        907, 918, 939,
        1000, 1018, 1040, 1058,
        1116, 1134, 1151,
        1209, 1221, 1234, 1247,
        1300, 1314, 1328, 1342, 1357,
        1413, 1427, 1443, 1459,
        1515, 1531, 1546,
        1605, 1625, 1643,
        1701, 1727, 1738, 1758,
        1814, 1841,
        1902, 1927,
        2002, 2033 ]

busListSunday40 = [ 613, 623, 631,
        856,
        918, 954,
        1034, 1055,
        1114, 1159,
        1210,
        1343,
        1548,
	1608, 1628, 1650,
	1708, 1720,
        1849,
        1911, 1934 ]
        
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
        robot.hear /^平日の(|池袋)バス/, (msg) ->

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


        robot.hear /^土曜の(|池袋)バス/, (msg) ->

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

        robot.hear /^(日曜|祝日)の(|池袋)バス/, (msg) ->

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



        robot.hear /^(|池袋)バス$/, (msg) ->

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
                                                        busTimeStr = busTimeStrInFour[0]+"時"+busTimeStrInFour[1..2]+"分"
                                                else
                                                        busTimeStr = busTimeStrInFour[0..1]+"時"+busTimeStrInFour[2..3]+"分"
        
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
                                                        busTimeStr = busTimeStrInFour[0]+"時"+busTimeStrInFour[1..2]+"分"
                                                else
                                                        busTimeStr = busTimeStrInFour[0..1]+"時"+busTimeStrInFour[2..3]+"分"

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
                                                        busTimeStr = busTimeStrInFour[0]+"時"+busTimeStrInFour[1..2]+"分"
                                                else
                                                        busTimeStr = busTimeStrInFour[0..1]+"時"+busTimeStrInFour[2..3]+"分"

                                                busFromNow += busTimeStr

                                                icount += 1

                                                if icount is 4
                                                        break

                                if icount is 0
                                        busFromNow="終わりました"

                                msg.send "日曜の池袋行きバスは#{busFromNow}"
