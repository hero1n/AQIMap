//
//  MainViewModel.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/09.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum MainViewModelError: Error {
    case noCoordinate
}

class MainViewModel: NSObject {
    // MARK: - Rx Variables
    var pointA: BehaviorRelay<Point?> = BehaviorRelay(value: nil)
    var pointB: BehaviorRelay<Point?> = BehaviorRelay(value: nil)
    
    // MARK: - Variables
    var canMoveInfo: Bool {
        return self.pointA.value != nil && self.pointB.value != nil
    }
    
    override init() {
        super.init()
    }
    
    public func clearPoint() {
        self.pointA.accept(nil)
        self.pointB.accept(nil)
    }
    
    public func setPointA(point: Point) {
        self.pointA.accept(point)
    }
    
    public func setPointB(point: Point) {
        self.pointB.accept(point)
    }
    
    public func observePointA() -> Observable<Point?> {
        return self.pointA.asObservable().observeOn(MainScheduler())
    }
    
    public func observePointB() -> Observable<Point?> {
        return self.pointB.asObservable().observeOn(MainScheduler())
    }
    
    public func getAdditionalInfo(from point: Point) -> Observable<(Geocode?, AQI?)> {
        guard let latitude = point.latitude, let longitude = point.longitude else {
            return Observable.error(MainViewModelError.noCoordinate)
        }
        
        let geocodeObservable = self.requestGeocode(latitude: latitude, longitude: longitude)
            .map { $0 as? Geocode }
            .catchErrorJustReturn(nil)
        
        let aqiObservable = self.requestAQI(latitude: latitude, longitude: longitude)
            .map { $0 as? AQI }
            .catchErrorJustReturn(nil)
        
        return Observable.zip(geocodeObservable, aqiObservable, resultSelector: { return ($0, $1) })
    }
}

// MARK: - Networking
extension MainViewModel {
    func requestGeocode(latitude: Double, longitude: Double) -> Observable<Geocode> {
        return AlamofireManager.shared.rx_requestObject(
            .getGeocode(latitude: latitude, longitude: longitude)
        )
    }
    
    func requestAQI(latitude: Double, longitude: Double) -> Observable<AQI> {
        return AlamofireManager.shared.rx_requestObject(
            .getAQI(latitude: latitude, longitude: longitude),
            keyPath: "data")
    }
}
