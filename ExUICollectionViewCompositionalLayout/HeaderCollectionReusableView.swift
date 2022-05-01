//
//  HeaderCollectionReusableView.swift
//  ExUICollectionViewCompositionalLayout
//
//  Created by Kant on 2022/04/24.
//

import Foundation
import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "APPLE MUSIC 추천"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    public func configure() {
        backgroundColor = .systemPink
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
