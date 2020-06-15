//
//  GMSMarker.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/09.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreLocation

extension GMSMarker {
    func toDictionary() -> Dictionary<String, Any> {
        return ["latitude": self.position.latitude,
                "longitude": self.position.longitude,
                "title": self.title ?? "",
                "snippet": self.snippet ?? ""]
    }
    
    static func from(dictionary: Dictionary<String, Any?>) -> GMSMarker {
        return GMSMarker().then {
            if let latitude = dictionary["latitude"] as? Double,
                let longitude = dictionary["longitude"] as? Double {
                $0.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                $0.title = dictionary["title"] as? String
                $0.snippet = dictionary["snippet"] as? String
            }
        }
    }
}
