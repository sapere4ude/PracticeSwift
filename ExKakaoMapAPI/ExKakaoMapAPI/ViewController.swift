//
//  ViewController.swift
//  ExKakaoMapAPI
//
//  Created by kant on 2022/11/30.
//

import UIKit

class ViewController: UIViewController, MTMapViewDelegate {

    var mapView: MTMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MTMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.baseMapType = .standard
        self.view.addSubview(mapView)
    }
}

