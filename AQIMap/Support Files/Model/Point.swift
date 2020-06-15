//
//  Point.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/06.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation

class Point {
    var latitude: Double?
    var longitude: Double?
    var aqi: Int?
    var name: String?
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func update(geocode: Geocode?, aqi: AQI?) {
        if let geocode = geocode {
            self.name = geocode.localityInfo?.administrative?
                .sorted{ $0.order ?? 0 < $1.order ?? 0}
                .suffix(2)
                .compactMap { $0.name }
                .joined(separator: " ")
        }
        
        if let aqi = aqi {
            self.aqi = aqi.aqi
        }
    }
}
