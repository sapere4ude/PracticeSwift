//
//  SampleView.swift
//  ExOpenUIViewCustom
//
//  Created by eileenyou on 2022/05/11.
//

import Foundation
import UIKit

class SampleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let name = String(describing: type(of: self))
        
        // UINib
        let nib = UINib(nibName: name, bundle: Bundle.main)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { // 타입 캐스팅이 UIView
            return
        }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
