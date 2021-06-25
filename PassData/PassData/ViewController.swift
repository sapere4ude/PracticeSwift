//
//  ViewController.swift
//  PassData
//
//  Created by Kant on 2021/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var delegateLabel: UILabel!
    @IBOutlet weak var completionLabel: UILabel!
    
    let passDataVC = PassDataViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        passDataVC.delegate = self
    }
    
    @IBAction func Move(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PassDataViewController")
        
        passDataVC.completion = { passData in
            self.completionLabel.text = passData
        }
        
        self.present(vc!, animated: true, completion: nil)
    }
    
}

extension ViewController: passDataDelegate {
    func passData(text: String) {
        self.delegateLabel.text = text
        print("\(String(describing: self.delegateLabel.text))")
    }
}
