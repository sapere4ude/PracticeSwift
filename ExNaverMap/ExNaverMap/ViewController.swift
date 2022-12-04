//
//  ViewController.swift
//  ExNaverMap
//
//  Created by kant on 2022/12/04.
//

import UIKit
import SnapKit
import NMapsMap
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    private var locationManager = CLLocationManager()
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.touchDelegate = self
        
        configureSubViews()
        configureUI()
        configureLocation()
        configureCurrentPositionMarker()
    }
    
    // MARK: UI
    func configureSubViews() {
        view.addSubview(mapView)
    }

    func configureUI() {
        mapView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(750)
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    // TODO: 권한 설정 받는 부분 어떤 방식으로 처리??
    func configureLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
//        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 ON")
            locationManager.startUpdatingLocation()
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
        
//        } else {
//            print("위치 서비스 OFF")
//        }
    }
    
    // MARK: - 현재 위치 마커 생성
    func configureCurrentPositionMarker() {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0)
        marker.mapView = mapView
    }
}

// MARK: - 지도 위 내가 클릭한 곳으로 카메라 이동
extension ViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latlng.lat, lng: latlng.lng))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
   }
}
