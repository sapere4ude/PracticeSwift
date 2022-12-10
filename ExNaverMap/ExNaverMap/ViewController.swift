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
    
    // 어쨌든 마커 배열은 한곳에서 관리되는 것이 맞음
    var markerArray: [NMFMarker]?
    
    // pickMemoModel 타입의 값은 싱글톤으로 관리되어야함
    var pickMemos: [PickMemoModel]? = []
    
    var caption: String?
    var isCreateMarker: Bool = true
    var isRegisterCaption: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.touchDelegate = self
        
        configureSubViews()
        configureUI()
        configureLocation()
//        configureCurrentPositionMarker()
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
//        marker.
        marker.mapView = mapView
    }
}

// MARK: - 지도 위 내가 클릭한 곳으로 카메라 이동
extension ViewController: NMFMapViewTouchDelegate {
    
    /*
     didTap & point -> 마커가 있어야지만 타는 코드
     caption 여부로 1차 판단
     
     */
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        print("kant, test2")
        if(symbol.caption.count > 0) {
            caption = symbol.caption
            pickMemos?.forEach({ pickMemo in
                if pickMemo.caption == symbol.caption {
                    isCreateMarker = false
                }
            })
            isRegisterCaption = false
            return false // 마커 만들 수 있다
        } else {
            return true // 마커 만들 수 없다
        }
    }
    
    // 캡션 값 없이 바로 진입 가능
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("kant, test1")
        // guard 문 -> 이 값이 맞아야해. 그렇지 않으면 조건문 타지 않아
        guard isCreateMarker == true else { return }
        guard isRegisterCaption == false else { return }
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latlng.lat, lng: latlng.lng)) 
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)

        var pickMemoData = [PickMemoModel]()
        let pickMemo = PickMemoModel(latlng: latlng, caption: caption)
        pickMemos?.append(pickMemo)
        createMarker(latlng: latlng)
        
        
        isRegisterCaption = true
        
        /*
         해당 지점에 마커가 있다? > 해당 내용 보여주는 VC
         해당 지점에 마커가 없다? > 메모생성 VC
         */
   }
    
    // TODO: 마커가 찍히는 부분을 캡션값이 있는 것에 한에서 찍어줄 것. 캡션을 벗어나는 값이면 찍지 않기
    // 현재 문제점은 캡션을 벗어난 곳을 찍었지만 계속해서 didTapMap 메서드가 불리고 있는점
    // for in 문을 통해 캡션 여부 파악을 진행하지만 정상 동작하지 않는 점
}
