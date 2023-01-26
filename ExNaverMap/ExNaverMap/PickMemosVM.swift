//
//  PickMemosVM.swift
//  ExNaverMap
//
//  Created by kant on 2022/12/11.
//

import Foundation
import Combine
import NMapsMap

class PickMemosVM: ObservableObject {
    
    @Published var pickMemos: [PickMemoModel] = []
    //var subscriptions = Set<AnyCancellable>()
    
    // 메모 추가
    func addMemo(text: String?, latlng: NMGLatLng?, symbol: NMFSymbol?) {
        pickMemos.append(PickMemoModel(text: text, latlng: latlng, symbol: symbol))
    }
    
    // 메모 삭제
    func removeMemo(text: String?, latlng: NMGLatLng?, symbol: NMFSymbol?) {
        pickMemos.append(PickMemoModel(text: text, latlng: latlng, symbol: symbol))
    }
    
    // 메모 수정
}
