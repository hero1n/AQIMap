//
//  Geocode.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/06.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import ObjectMapper

struct Geocode: Mappable {
    var latitude: Double?
    var longitude: Double?
    var localityInfo: LocalityInfo?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.latitude <- map["latitude"]
        self.longitude <- map["longitude"]
        self.localityInfo <- map["localityInfo"]
    }
}

struct LocalityInfo: Mappable {
    var administrative: [Administrative]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.administrative <- map["administrative"]
    }
}

struct Administrative: Mappable {
    var order: Int?
    var name: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.order <- map["order"]
        self.name <- map["name"]
    }
}


/*
JSON Raw
{
"latitude": 37.42158889770508,
"longitude": -122.08370208740234,
"localityLanguageRequested": "ko",
"continent": "북아메리카",
"continentCode": "NA",
"countryName": "미국",
"countryCode": "US",
"principalSubdivision": "캘리포니아주",
"principalSubdivisionCode": "US-CA",
"city": "마운틴뷰",
"locality": "마운틴뷰",
"postcode": "94043",
-"localityInfo": {
-"administrative": [
-{
"order": 1,
"adminLevel": 2,
"name": "미국",
"description": "북아메리카에 위치한 연방 공화국",
"isoName": "United States of America (the)",
"isoCode": "US",
"wikidataId": "Q30"
},
-{
"order": 3,
"adminLevel": 4,
"name": "캘리포니아주",
"description": "미국의 주",
"isoName": "California",
"isoCode": "US-CA",
"wikidataId": "Q99"
},
-{
"order": 5,
"adminLevel": 6,
"name": "샌타클라라 군",
"description": "county in California, United States",
"wikidataId": "Q110739"
},
-{
"order": 6,
"adminLevel": 8,
"name": "마운틴뷰",
"description": "city in Santa Clara County, California, United States",
"wikidataId": "Q486860"
}
],
-"informative": [
-{
"order": 0,
"name": "북아메리카",
"description": "continent on the Earth's northwestern quadrant",
"isoCode": "NA",
"wikidataId": "Q49"
},
-{
"order": 2,
"name": "미국 본토",
"description": "48 states of the United States apart from Alaska and Hawaii",
"wikidataId": "Q578170"
},
-{
"order": 4,
"name": "Pacific Coast Ranges",
"description": "mountain ranges in North America",
"wikidataId": "Q660304"
},
-{
"order": 7,
"name": "94043",
"description": "우편번호"
},
-{
"order": 8,
"name": "구글플렉스",
"description": "building complex in California, United States",
"wikidataId": "Q694178"
}
]
}
}
*/
