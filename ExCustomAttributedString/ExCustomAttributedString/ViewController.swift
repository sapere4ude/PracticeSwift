//
//  ViewController.swift
//  ExCustomAttributedString
//
//  Created by kant on 2022/09/28.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.text = "<b>Hello</b> World! 테스트중<br>입니다."
        testLabel.setHTMLFromString(htmlText: "<b>Hello</b> World! 테스트중<br>입니다.")
    }
}

extension UILabel {
    /**
    html 태그가 달린 string 문자열을 html 형식에 맞게 그대로 적용해줄 수 있는 메서드
     */
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}
