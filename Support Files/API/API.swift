//
//  API.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/06.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import Alamofire

enum API {
    case getGeocode(latitude: Double, longitude: Double)
    case getAQI(latitude: Double, longitude: Double)
}

extension API {
    var method: HTTPMethod {
        switch self {
        case .getGeocode, .getAQI: return .get
        }
    }
    
    var url: URLConvertible {
        switch self {
        case .getGeocode: return "https://api.bigdatacloud.net/data/reverse-geocode-client/"
        case .getAQI(let latitude, let longitude): return "https://api.waqi.info/feed/geo:\(latitude);\(longitude)/"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getGeocode(let latitude, let longitude):
            return ["latitude": "\(latitude)", "longitude": "\(longitude)", "localityLanguage": "ko"]
        case .getAQI:
            return ["token": KeyConstants.AQI_KEY]
        default:
            return [:]
        }
    }
}
