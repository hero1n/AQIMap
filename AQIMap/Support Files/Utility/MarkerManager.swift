//
//  MarkerManager.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/09.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import GoogleMaps
import RxSwift
import RxCocoa
import Then

class MarkerManager {
    static let shared: MarkerManager = MarkerManager()
    
    private var markersBehaviorRelay: BehaviorRelay<[GMSMarker]> = BehaviorRelay(value: [])
    var markers: [GMSMarker] {
        get {
            self.markersBehaviorRelay.value
        }
        set {
            self.markersBehaviorRelay.accept(newValue)
            self.syncronize()
        }
    }
    
    init() {
        if let markerDicts = Defaults[\.markers] {
            self.markers = markerDicts.map {
                GMSMarker.from(dictionary: $0)
            }
        }
    }
    
    func addMarker(_ marker: GMSMarker) {
        self.markers.append(marker)
    }
    
    func removeMarker(at position: Int) {
        self.markers.remove(at: position)
    }
    
    func observeMarkers() -> Observable<[GMSMarker]> {
        return self.markersBehaviorRelay.asObservable()
    }
    
    func syncronize() {
        Defaults[\.markers] = self.markers.map {
            $0.toDictionary()
        }
    }
}
