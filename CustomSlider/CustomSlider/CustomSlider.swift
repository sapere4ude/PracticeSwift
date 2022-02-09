//
//  CustomSlider.swift
//  CustomSlider
//
//  Created by Kant on 2022/01/19.
//

import Foundation
import UIKit

@IBDesignable
class CustomSlider: UISlider {
    
//    @IBInspectable var color: UIColor = .gray {
//        didSet { setNeedsDisplay() }
//    }
//
//    override var value: Float {
//        didSet { setNeedsDisplay() }
//    }
//
//    private let progressLayer = CALayer()
//    private let backgroundMask = CAShapeLayer()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupLayers()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupLayers()
//    }
//
//    var trackWidth:CGFloat = 2 {
//        didSet {setNeedsDisplay()}
//    }
//
//    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
//        let defaultBounds = super.trackRect(forBounds: bounds)
//        return CGRect(
//            x: defaultBounds.origin.x,
//            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
//            width: defaultBounds.size.width,
//            height: trackWidth
//        )
//    }
//
//    private func setupLayers() {
//        layer.addSublayer(progressLayer)
//    }
//
//    override func draw(_ rect: CGRect) {
////        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
////        layer.mask = backgroundMask
//
//        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * CGFloat(value), height: rect.height))
//
////        progressLayer.frame = progressRect
////        progressLayer.backgroundColor = color.cgColor
//
//        layer.frame = progressRect
//        layer.backgroundColor = color.cgColor
//    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 20))
    }
    
    fileprivate func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func setSliderThumbTintColor(_ color: UIColor) {
        let circleImage = makeCircleWith(size: CGSize(width: 20, height: 20),
                       backgroundColor: color)
        self.setThumbImage(circleImage, for: .normal)
        self.setThumbImage(circleImage, for: .highlighted)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//        let width = self.frame.size.width
//
//        let tapPoint = touch.location(in: self)
//
//        let fPercent = tapPoint.x/width
//
//        let nNewValue = self.maximumValue * Float(fPercent)
//
//        if nNewValue != self.value {
//            self.value = nNewValue
//        }
        
        let tapPoint = touch.location(in: self)
        let fraction = Float(tapPoint.x / bounds.width)
        let newValue = (maximumValue - minimumValue) * fraction + minimumValue
        
        if newValue != value {
            value = newValue
            sendActions(for: .valueChanged)
        }
        
        return true
    }
}

