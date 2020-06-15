//
//  DefaultKeys.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/09.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    var markers: DefaultsKey<Array<Dictionary<String, Any>>?> { .init("markers") }
}
