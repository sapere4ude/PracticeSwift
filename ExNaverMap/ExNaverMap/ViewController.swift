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
import Combine

class ViewController: UIViewController, CLLocationManagerDelegate {

    var isCreateMarker: Bool = true
    var isRegisterCaption: Bool = true
    
    private var locationManager = CLLocationManager()
    
    var naverMapProxy = NaverMapProxy()
    
    var pickMemos = PickMemosVM()
    
    var subscriptions = Set<AnyCancellable>()
    
    private let mapView: NMFMapView = {
        let mapView = NMFMapView()
        return mapView
    }()
    
    // 어쨌든 마커 배열은 한곳에서 관리되는 것이 맞음
    var markerArray: [NMFMarker]?
    
    // pickMemoModel 타입의 값은 싱글톤으로 관리되어야함
//    var pickMemos: [PickMemoModel]? = []
    
    var caption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        pickMemos.$pickMemos
        
        //mapView.touchDelegate = self
        mapView.touchDelegate = naverMapProxy
        
        configureSubViews()
        configureUI()
        configureLocation()
//        configureCurrentPositionMarker()
        
        naverMapProxy.$tapPosition.sink { tapPosition in
            print("tapPosition: \(tapPosition)")
            self.createMarker(latlng: tapPosition)
        }.store(in: &subscriptions) // & <- inout
        
        
        // PassthroughSubject 형태의 변수 값을 이렇게 가져올 수 있다.
//        naverMapProxy.outputAction
//            .receive(on: DispatchQueue.main)
//            .sink { value in
//                print(value)
//            }
//            .store(in: &subscriptions)
    }
    
    // MARK: UI
    func configureSubViews() {
        view.addSubview(mapView)
    }

    func configureUI() {
        mapView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(-70)
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
    
    // 입력 받은 위치에 대한 마커 생성
    func createMarker(latlng: NMGLatLng?) {
        guard let latlng = latlng else { return }
        let marker = NMFMarker()
        marker.position = latlng
        marker.mapView = mapView
        
        let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
            if let marker = overlay as? NMFMarker {
                if marker.infoWindow == nil {
                    // 현재 마커에 정보 창이 열려있지 않을 경우 엶
                    //                    self?.infoWindow.open(with: marker)
                } else {
                    // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
                    //                    self?.infoWindow.close()
                }
            }
            return true
        };
        marker.touchHandler = handler
    }
}
