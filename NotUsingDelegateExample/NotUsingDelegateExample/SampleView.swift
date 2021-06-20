//
//  SampleView.swift
//  NotUsingDelegateExample
//
//  Created by Kant on 2021/06/19.
//

import UIKit
import Foundation

class SampleView: UIView {
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SmapleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}
