//
//  AQI.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/06.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import ObjectMapper

struct AQI: Mappable {
    var aqi: Int?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.aqi <- map["aqi"]
    }
}

//{
//    "status": "ok",
//    "data": {
//        "aqi": 46,
//        "idx": 1437,
//        "attributions": [
//            {
//                "url": "https://sthj.sh.gov.cn/",
//                "name": "Shanghai Environment Monitoring Center(上海市环境监测中心)"
//            },
//            {
//                "url": "http://106.37.208.233:20035/emcpublish/",
//                "name": "China National Urban air quality real-time publishing platform (全国城市空气质量实时发布平台)"
//            },
//            {
//                "url": "https://china.usembassy-china.org.cn/embassy-consulates/shanghai/air-quality-monitor-stateair/",
//                "name": "U.S. Consulate Shanghai Air Quality Monitor"
//            },
//            {
//                "url": "https://waqi.info/",
//                "name": "World Air Quality Index Project"
//            }
//        ],
//        "city": {
//            "geo": [
//                31.2047372,
//                121.4489017
//            ],
//            "name": "Shanghai (上海)",
//            "url": "https://aqicn.org/city/shanghai"
//        },
//        "dominentpol": "pm25",
//        "iaqi": {
//            "co": {
//                "v": 7.3
//            },
//            "h": {
//                "v": 72.2
//            },
//            "no2": {
//                "v": 11.9
//            },
//            "p": {
//                "v": 1007.5
//            },
//            "pm10": {
//                "v": 20
//            },
//            "pm25": {
//                "v": 46
//            },
//            "so2": {
//                "v": 1.1
//            },
//            "t": {
//                "v": 23.3
//            },
//            "w": {
//                "v": 0.1
//            }
//        },
//        "time": {
//            "s": "2020-06-06 20:00:00",
//            "tz": "+08:00",
//            "v": 1591473600
//        },
//        "debug": {
//            "sync": "2020-06-06T22:15:46+09:00"
//        }
//    }
//}
