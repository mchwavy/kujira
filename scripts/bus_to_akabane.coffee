# Description
#   A Hubot script that tells bus time
# 
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#  平日の赤羽バス - 平日の赤羽行きバス
#  土曜の赤羽バス - 土曜の赤羽行きバス
#  日曜の赤羽バス - 日曜の赤羽行きバス
#  赤羽バス - 赤羽行きバス直近4本の時間
#
# Notes:
#
# Author:
#   mchwavy

busListWeekday = [ 610, 629, 642, 655,
        709, 718, 727, 736, 746, 757,
        808, 819, 830, 842, 854,
        906, 918, 930, 942, 954,
        1004, 1016, 1029, 1045,
        1101, 1115, 1128, 1142, 1156,
        1212, 1227, 1241, 1255,
        1309, 1323, 1338, 1353,
        1409, 1423, 1437, 1451,
        1506, 1522, 1538, 1553
        1607, 1621, 1636, 1651,
        1706, 1721, 1736, 1751,
        1806, 1820, 1835, 1850,
        1909, 1929, 1952,
        2014, 2038,
        2107, 2129, 2152,
        2221, 2244 ]

busListSaturday = [ 610, 631, 656
        717, 737, 758,
        820, 844,
        902, 920, 938, 957,
        1011, 1025, 1039, 1053,
        1107, 1121, 1135, 1149,
        1203, 1217, 1231, 1245,
        1301, 1317, 1333, 1349,
        1406, 1423, 1440, 1457,
        1514, 1531, 1548,
        1604, 1620, 1635, 1651,
        1706, 1721, 1736, 1752,
        1811, 1831, 1851,
        1914, 1933, 1952,
        2011, 2034, 2055,
        2115, 2135, 2155,
        2221, 2243 ]

busListSunday = [ 610, 645,
        715, 740,
        808, 836, 858
        920, 939, 958,
        1017, 1037, 1056,
        1115, 1131, 1146,
        1201, 1214, 1227, 1240, 1253,
        1306, 1319, 1332, 1345, 1358,
        1411, 1424, 1437, 1450,
        1505, 1519, 1533, 1548,
        1603, 1617, 1631, 1647,
        1703, 1726, 1744,
        1802, 1819, 1836, 1855,
        1916, 1938,
        2000, 2030, 2056,
        2124, 2153,
        2222, 2244 ]

module.exports = (robot) ->
        robot.hear /^平日の赤羽バス/, (msg) ->

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

                msg.send "平日の赤羽行きバスは#{busFromNow}"


        robot.hear /^土曜の赤羽バス/, (msg) ->

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

                msg.send "土曜の赤羽行きバスは#{busFromNow}"

        robot.hear /^(日曜|祝日)の赤羽バス/, (msg) ->

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

                msg.send "日曜祝日の赤羽行きバスは#{busFromNow}"



        robot.hear /^赤羽バス$/, (msg) ->

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

                                msg.send "平日の赤羽行きバスは#{busFromNow}"

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

                                msg.send "土曜の赤羽行きバスは#{busFromNow}"

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

                                msg.send "日曜の赤羽行きバスは#{busFromNow}"
