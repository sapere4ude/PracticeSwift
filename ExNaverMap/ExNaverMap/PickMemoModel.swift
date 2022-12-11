//
//  PickMemoModel.swift
//  ExNaverMap
//
//  Created by kant on 2022/12/05.
//

import Foundation
import NMapsMap

struct PickMemoModel {
    var text: String?
    var lat: Double?
    var lng: Double?
    var latlng: NMGLatLng?
    var symbol: NMFSymbol?
    var marker: [NMFMarker]?
}
