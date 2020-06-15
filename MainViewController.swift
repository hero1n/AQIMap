//
//  ViewController.swift
//  AQIMap
//
//  Created by jaewon on 2020/06/04.
//  Copyright © 2020 jaewon. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import RxSwift
import ReactorKit

class MainViewController: UIViewController, StoryboardView {
    enum PointStatus {
        case a
        case b
        case none
    }

    enum ViewStatus: Equatable {
        case map(point: PointStatus)
        case main
        case info
        
        static func ==(lhs: ViewStatus, rhs: ViewStatus) -> Bool {
            switch (lhs, rhs) {
            case (let .map(lhsPoint), let .map(rhsPoint)):
                return lhsPoint == rhsPoint
            case (.main, .main):
                return true
            case (.info, .info):
                return true
            default:
                return false
            }
        }
    }
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Map Screen
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var mapToolBar: UIToolbar!
    @IBOutlet var markerTableView: UITableView!
    @IBOutlet var setBarButton: UIBarButtonItem!
    @IBOutlet var centeredMarkerImageView: UIImageView!
    
    // MARK: - Main Screen
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var setAButton: UIButton!
    @IBOutlet var setBButton: UIButton!
    @IBOutlet var pointALabel: UILabel!
    @IBOutlet var pointBLabel: UILabel!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var mainTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet var mainBottomMarginConstraint: NSLayoutConstraint!
    
    // MARK: - Info Screen
    @IBOutlet var backBarButton: UIBarButtonItem!
    @IBOutlet var infoContainerView: UIView!
    @IBOutlet var infoToolBar: UIToolbar!
    @IBOutlet var pointACoordinateLabel: UILabel!
    @IBOutlet var pointANameLabel: UILabel!
    @IBOutlet var pointAAQILabel: UILabel!
    @IBOutlet var pointBCoordinateLabel: UILabel!
    @IBOutlet var pointBNameLabel: UILabel!
    @IBOutlet var pointBAQILabel: UILabel!
    @IBOutlet var infoTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet var infoBottomMarginConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    fileprivate let viewModel = MainViewModel()
    
    var isLoading: Bool = false {
        didSet {
            self.activityIndicatorView.isHidden = !self.isLoading
        }
    }
    
    var viewStatus: ViewStatus = .main
    var initializedInfoView: Bool = false
    var centeredMarker = GMSMarker()
    
    let locationManager = CLLocationManager()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureLocationManger()
        self.subscribeButtonEvent()
        self.configureMarkerTableView()
        self.observeViewModel()
        self.setupMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !self.initializedInfoView {
            self.infoToolBar.isHidden = true
            self.infoTopMarginConstraint.constant = self.view.frame.size.height
            self.infoBottomMarginConstraint.constant = self.view.frame.size.height
            self.view.layoutIfNeeded()
            self.initializedInfoView = true
        }
    }
    
    func bind(reactor: MainViewReactor) {
//        reactor.state
//            .map { $0.viewStatus }
//            .distinctUntilChanged()
//            .subscribe(onNext: { (viewStatus) in
//                switch viewStatus {
//                case .map: self.showMap(point: )
//                }
//            })
//            .disposed(by: self.disposeBag)
//
//        reactor.state
//            .map { $0.isLoading }
//            .distinctUntilChanged()
//            .bind(to: self.activityIndicatorView.rx.isAnimating)
//            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Funcs
    func configureLocationManger() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func subscribeButtonEvent() {
        self.setAButton.rx.tap.asDriver().drive(onNext: { _ in
            self.showMap(point: .a)
        }).disposed(by: self.disposeBag)
        
        self.setBButton.rx.tap.asDriver().drive(onNext: { _ in
            self.showMap(point: .b)
        }).disposed(by: self.disposeBag)
        
        self.setBarButton.rx.tap.asDriver().drive(onNext: { _ in
            self.setPoint()
        }).disposed(by: self.disposeBag)
        
        self.backBarButton.rx.tap.asDriver().drive(onNext: { _ in
            self.viewModel.clearPoint()
            self.hideInfo()
        }).disposed(by: self.disposeBag)
    }
    
    func configureMarkerTableView() {
        self.markerTableView.layer.cornerRadius = 10.0
        self.markerTableView.tableFooterView = UIView()
        
        MarkerManager.shared.observeMarkers().subscribe { (markers) in
            self.markerTableView.isHidden = (markers.element?.count ?? 0) == 0
        }.disposed(by: self.disposeBag)
        
        MarkerManager.shared.observeMarkers().bind(to: self.markerTableView.rx.items(
            cellIdentifier: MarkerTableViewCell.identifier, cellType: MarkerTableViewCell.self
            )) { (index: Int, element: GMSMarker, cell: MarkerTableViewCell) in
                cell.marker = element
                cell.setRemoveButtonAction().asDriver()
                    .drive(onNext: { _ in
                        MarkerManager.shared.removeMarker(at: index)
                        element.map = nil
                    }).disposed(by: cell.disposeBag)
            }.disposed(by: self.disposeBag)
        
        self.markerTableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }
    
    func observeViewModel() {
        self.viewModel.observePointA()
            .subscribe(onNext: { (point) in
                if let point = point, let latitude = point.latitude, let longitude = point.longitude {
                    self.pointALabel.text = "Coord: (%@, %@)".localized(
                        with: "\(latitude.rounded(toPlaces: 6))", "\(longitude.rounded(toPlaces: 6))")
                    
                    self.pointACoordinateLabel.text = "(\(latitude.rounded(toPlaces: 6)), \(longitude.rounded(toPlaces: 6)))"
                    self.pointANameLabel.text = "\(point.name ?? "")"
                    self.pointAAQILabel.text = "\(point.aqi ?? 0)"
                } else {
                    self.pointALabel.text = "Point A".localized
                }
            }, onError: { (error) in
                print(debug: error)
            }).disposed(by: self.disposeBag)
        
        self.viewModel.observePointB()
            .subscribe(onNext: { (point) in
                if let point = point, let latitude = point.latitude, let longitude = point.longitude {
                    self.pointBLabel.text = "Coord: (%@, %@)".localized(
                        with: "\(latitude.rounded(toPlaces: 6))", "\(longitude.rounded(toPlaces: 6))")
                    
                    self.pointBCoordinateLabel.text = "(\(latitude.rounded(toPlaces: 6)), \(longitude.rounded(toPlaces: 6)))"
                    self.pointBNameLabel.text = "\(point.name ?? "")"
                    self.pointBAQILabel.text = "\(point.aqi ?? 0)"
                } else {
                    self.pointBLabel.text = "Point B".localized
                }
            }, onError: { (error) in
                print(debug: error)
            }).disposed(by: self.disposeBag)
    }
    
    func setupMap() {
        self.mapView.delegate = self
        self.mapView.settings.rotateGestures = false
        self.mapView.settings.tiltGestures = false
        
        self.centeredMarker.map = self.mapView
        self.centeredMarker.icon = UIImage()
        
        MarkerManager.shared.markers.forEach {
            _ = $0.then { (marker) in marker.map = self.mapView }
        }
    }
    
    func setPoint() {
        let position = self.centeredMarker.position
        let point = Point(latitude: position.latitude, longitude: position.longitude)
        
        self.isLoading = true
        
        self.viewModel.getAdditionalInfo(from: point)
            .subscribe(
                onNext: { (response: (geocode: Geocode?, aqi: AQI?)) in
                point.update(geocode: response.geocode, aqi: response.aqi)
                self.addMarker(position: position, point: point)
                
                if case .map = self.viewStatus {
                    self.isLoading = false
                    
                    if self.viewStatus == .map(point: .a) {
                        self.viewModel.setPointA(point: point)
                    } else if self.viewStatus == .map(point: .b) {
                        self.viewModel.setPointB(point: point)
                    }
                    
                    if self.viewModel.canMoveInfo {
                        self.showInfo()
                    } else {
                        self.showMain()
                    }
                }
            }, onError: { (error) in
                print(debug: error)
                self.isLoading = false
            }).disposed(by: self.disposeBag)
    }
    
    func addMarker(position: CLLocationCoordinate2D, point: Point) {
        let marker = GMSMarker()
        marker.position = position
        marker.title = point.name
        marker.snippet = "AQI: %@".localized(with: "\(point.aqi ?? 0)")
        marker.map = self.mapView
        
        MarkerManager.shared.addMarker(marker)
    }
}

// MARK: - Transition
extension MainViewController {
    func hideMain() {
        UIView.animate(withDuration: 0.3) {
            self.mainTopMarginConstraint.constant = self.view.frame.size.height
            self.mainBottomMarginConstraint.constant = self.view.frame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func hideInfo() {
        UIView.animate(withDuration: 0.3) {
            self.infoToolBar.isHidden = true
            self.infoTopMarginConstraint.constant = self.view.frame.size.height
            self.infoBottomMarginConstraint.constant = self.view.frame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func showMap(point: PointStatus) {
        switch self.viewStatus {
        case .main:
            self.hideMain()
            self.viewStatus = .map(point: point)
        case .info:
            self.hideMain()
            self.hideInfo()
            self.viewStatus = .map(point: point)
        default: return
        }
    }
    
    func showMain() {
        if case .map = self.viewStatus {
            UIView.animate(withDuration: 0.3, animations:  {
                self.mainTopMarginConstraint.constant = 0
                self.mainBottomMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.viewStatus = .main
            })
        }
    }
    
    func showInfo() {
        UIView.animate(withDuration: 0.3, animations:  {
            self.infoToolBar.isHidden = false
            self.infoTopMarginConstraint.constant = 0
            self.infoBottomMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if case .map = self.viewStatus {
                self.showMain()
            }
            
            self.viewStatus = .info
        })
    }
}

// MARK: - Delegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
        let userLocation = locations[0]
        
        let camera = GMSCameraPosition.camera(withTarget: userLocation.coordinate, zoom: 17.0)
        self.mapView.camera = camera
    }
}

extension MainViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.centeredMarker.position = position.target
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedMarker = MarkerManager.shared.markers[indexPath.row]
        
        self.mapView.animate(to: GMSCameraPosition(target: selectedMarker.position, zoom: 17.0))
    }
}
