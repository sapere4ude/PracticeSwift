//
//  MemoReadVC.swift
//  MyMemory
//
//  Created by Kant on 2021/06/05.
//

import UIKit

class MemoReadVC: UIViewController {

    // 컨텐츠 데이터를 저장하는 변수
    var param: MemoData?
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.subject.text = param?.title
        self.contents.text = param?.contents
        self.img.image = param?.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd일 HH:mm분에 작성됨"
        let dateString = formatter.string(from: (param?.registerDate)!)
        
        self.navigationItem.title = dateString
    }
}
