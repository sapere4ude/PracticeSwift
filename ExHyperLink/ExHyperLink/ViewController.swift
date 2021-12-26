//
//  ViewController.swift
//  ExHyperLink
//
//  Created by Kant on 2021/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.text = "문자열에 특성 주는 것을 테스트합니당"

        let generalAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGreen,
                                                                .underlineColor: NSUnderlineStyle.single.rawValue,
                                                                .font: UIFont.boldSystemFont(ofSize: 20)]

        // 문자열을 커스텀하기전에 객체를 만들어주는 것이 포인트
        let mutableString = NSMutableAttributedString()
    
        mutableString.append(NSAttributedString(string: testLabel.text ?? "", attributes: generalAttributes))

        testLabel.attributedText = mutableString
    }
}

