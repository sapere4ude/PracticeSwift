//
//  ViewController.swift
//  ExCAShapeLayer
//
//  Created by Kant on 2022/01/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var customTextField: CustomUnderLineTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTextField.updateUnderLine()
    }
}

class CustomUnderLineTextField: UITextField {
    public var shapeLayeer: CAShapeLayer!
    
    func updateUnderLine() {
        borderStyle = .none
        
        let path = UIBezierPath() // path.bounds : (inf,inf, 0.0, 0.0)
        // move(to:) : 시작점
        path.move(to: CGPoint(x: 0, y: bounds.size.height - 8))    // bounds : (0,0,97,34) 인데 여기서 97,34 는 customTextField의 width, height를 의미한다.
        // addLine(to:) : 끝점
        path.addLine(to: CGPoint(x: bounds.width - 20, y: bounds.size.height - 8)) // path.bounds : (0.0, 37.0, 97.0, 47.0)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath   // 이 부분이 핵심. 위에서 UIBezierPath 속성으로 선언된 변수를 CAShapeLayer 속성에 넣어주는 것
        shapeLayer.lineWidth = path.lineWidth
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = UIColor.systemGreen.cgColor
        layer.addSublayer(shapeLayer)
    }
    
}
