//
//  NaverMapProxy.swift
//  ExNaverMap
//
//  Created by kant on 2022/12/11.
//

import Foundation
import Combine
import NMapsMap


// 델리겟 이벤트를 대신 받는 다는 관점으로 보면 Proxy : delegate -> Combine || delegate -> Rx
// 상태관리 측면으로 보면 [] 뷰모델, [] 서비스
// input?, output
// MVVM
// 들어오는 액션, 나가는 액션 - Reactor kit, TCA


// TODO: Notification -> Combine

enum UpdateMapAction {
    case createMarker(_ lat: NMGLatLng)
    case moveCamera
}

// TODO: 마커를 생성 하는 메서드 만들기, 마커 UI 생성하는 것만 VC 에서 작성해주기

class NaverMapProxy: NSObject, ObservableObject, NMFMapViewTouchDelegate {

    @Published var tapPosition: NMGLatLng? = nil
    @Published var symbol: NMFSymbol? = nil
    var outputAction = PassthroughSubject<UpdateMapAction, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    var isCreateMarker: Bool = true
    var isRegisterCaption: Bool = true
    var pickMemosVM = PickMemosVM()
    

    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        //        print("kant, 네이버맵에 지정된 장소입니다.")
//        if(symbol.caption.count > 0) {
//            //            caption = symbol.caption
//            // 저장된 메모에 동일한 장소의 이름 & 동일한 좌표를 갖고 있다면 마커를 만들 수 없습니다.
//            pickMemosVM.$pickMemos.sink { pickMemos -> Void in
//                pickMemos.forEach({ pickMemo in
//                    if pickMemo.symbol?.caption == symbol.caption && pickMemo.latlng == symbol.position {
//                        // TODO: 터치 이벤트가 존재하지 않으면 생성할 수 있도록 조건 추가하기 & pickMemo 안에서 마커도 관리할 수 있도록 수정
//                        self.symbol = symbol
//                        isCreateMarker = false
//                    }
//                })
//                isRegisterCaption = false
//                return false // 마커 만들 수 있다
//            }.store(in: &subscriptions)
//        } else {
//            return true // 마커 만들 수 없다
//        }
        
        if(symbol.caption.count > 0) {
            pickMemosVM.pickMemos.forEach { pickMemo in
                if pickMemo.symbol?.caption == symbol.caption && pickMemo.latlng == symbol.position {
                    // TODO: 터치 이벤트가 존재하지 않으면 생성할 수 있도록 조건 추가하기 & pickMemo 안에서 마커도 관리할 수 있도록 수정
                    self.symbol = symbol
                    isCreateMarker = false
                }
            }
            isRegisterCaption = false
            return false // 마커 만들 수 있다
        } else {
            return true // 마커 만들 수 없다
        }
    }
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        guard isCreateMarker == true else { return }
        guard isRegisterCaption == false else { return }

        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latlng.lat, lng: latlng.lng))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)

        isRegisterCaption = true

        tapPosition = latlng // 이 값을 전달해주면 VC에서 create Marker 진행됨
        pickMemosVM.addMemo(text: "test", latlng: latlng, symbol: self.symbol)
        //outputAction.send(.createMarker(tapPosition!))
    }
}
