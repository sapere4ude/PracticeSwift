//
//  ViewController.swift
//  ExUIViewSequence
//
//  Created by Kant on 2022/06/27.
//

import UIKit

class ViewController: UIViewController {

    var myView: UIView = MyView(frame: CGRect(x: 50, y: 200, width: 200, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(myView)
        
        myView.backgroundColor = .yellow
        
        let constraints1 = [
          self.myView.heightAnchor.constraint(equalToConstant: 300),
          self.myView.widthAnchor.constraint(equalToConstant: 300),
          self.myView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
          self.myView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ]
        NSLayoutConstraint.activate(constraints1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          NSLayoutConstraint.deactivate(constraints1)
          let constraints2 = [
            self.myView.heightAnchor.constraint(equalToConstant: 100),
            self.myView.widthAnchor.constraint(equalToConstant: 100),
            self.myView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.myView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
          ]
          NSLayoutConstraint.activate(constraints2)
        }

    }


}

final class MyView: UIView {
    override func updateConstraints() {
        super.updateConstraints()
        print("updateConstraints()")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews()")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("draw(rect:)")
    }
}
