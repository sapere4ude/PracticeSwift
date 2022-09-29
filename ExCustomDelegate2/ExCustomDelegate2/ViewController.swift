//
//  ViewController.swift
//  ExCustomDelegate2
//
//  Created by Kant on 2021/11/13.
//

import UIKit

class ViewController: UIViewController, ProcViewDelegate {
    
    @IBOutlet weak var deleBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // ProcViewDelegate에서 선언된 함수
    func didBtnClicked(data: String) {
        self.deleBtn.setTitle(data, for: .normal)
    }
    
    // #1
    @IBAction func deleBtnClicked(_ sender: UIButton) {
        if let procVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProcViewController") as? ProcViewController {
            procVC.procViewDelegate = self // 델리게이트 사용시 가장 핵심이 되는 부분. 매번 이걸 빼먹어서 델리게이트 동작이 안된다는 생각을함... 주의하자
            self.present(procVC, animated: true, completion: nil)
        }
    }
}

