//
//  String.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/09.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation

extension String {
     func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
     }

     var localized: String {
         return NSLocalizedString(self, comment:"")
     }
}
