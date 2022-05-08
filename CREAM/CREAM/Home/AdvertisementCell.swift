//
//  AdvertisementCell.swift
//  CREAM
//
//  Created by Kant on 2022/05/08.
//

import UIKit

final class AdvertisementCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false // 스토리보드를 통해 constraints 를 사용한다면 이 조건이 true가 되어야함.
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor(
            red: CGFloat(drand48()),
            green: CGFloat(drand48()),
            blue: CGFloat(drand48()),
            alpha: 1.0
        )
        self.contentView.addSubview(self.label)
        NSLayoutConstraint.activate([
            self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.prepare(text: "")
    }
    
    func prepare(text: String) {
        self.label.text = text
    }
}
