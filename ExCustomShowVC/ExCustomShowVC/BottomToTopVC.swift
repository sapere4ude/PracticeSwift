//
//  CustomVC.swift
//  ExCustomShowVC
//
//  Created by Kant on 2022/07/31.
//

import Foundation
import UIKit

class BottomToTopVC: PresentAnimateViewController {
    private lazy var backgroundView = UIView()
    private lazy var contentView = UIView()
    
    override func viewDidLoad() {
        setupUI()
        setupGesture()
    }
    
    func setupUI() {
        view.addSubview(self.backgroundView)
        view.addSubview(self.contentView)
        
        self.backgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // 실제 height 크기를 적어준다. top 영역은 제약을 주지 않는다.
        self.contentView.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.contentView.backgroundColor = UIColor.systemPink
        self.backgroundView.backgroundColor = UIColor.black
    }
    
    func setupGesture() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(didSelectDimmedView(_:)))
        backgroundView.addGestureRecognizer(dimmedTap)
    }
    
    @objc func didSelectDimmedView(_ recognizer: UITapGestureRecognizer) {
        hideBottomSheet()
    }
    
    func hideBottomSheet() {
        if self.presentationController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func onWillPresentView() {
        super.onWillPresentView()
        self.backgroundView.alpha = 0
        // 뷰가 보이지 않는걸 설정해주기 위해 높이를 0으로 둔다
        self.contentView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
    }
    
    override func performCustomPresentationAnimation() {
        self.backgroundView.alpha = 0.6
        self.contentView.snp.updateConstraints { (make) in
            // 최종 높이를 작성해준다.
            make.height.equalTo(200)
        }
    }
    
    override func performCustomDismissingAnimation() {
        self.contentView.snp.updateConstraints { (make) in
            // 최종 높이를 작성해준다.
            make.height.equalTo(0)
        }
    }
}
