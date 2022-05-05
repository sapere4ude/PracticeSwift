//
//  HeaderCollectionSecondReusableView.swift
//  ExUICollectionViewCompositionalLayout
//
//  Created by Kant on 2022/05/05.
//

import Foundation
import UIKit

class HeaderCollectionSecondReusableView: UICollectionReusableView {
    static let identifier = "HeaderCollectionSecondReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Youtube MUSIC 추천"
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
