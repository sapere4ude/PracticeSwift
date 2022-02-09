//
//  ViewController.swift
//  CustomSlider
//
//  Created by Kant on 2022/01/19.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var horizontalBar: PlainHorizontalProgressBar!
    
    @IBOutlet weak var customSlider: CustomSlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customSlider.setSliderThumbTintColor(.yellow)
    }


}

