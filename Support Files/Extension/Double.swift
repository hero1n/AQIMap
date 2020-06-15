//
//  Double.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/08.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
