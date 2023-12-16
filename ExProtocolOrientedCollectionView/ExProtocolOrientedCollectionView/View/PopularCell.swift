//
//  PopularCell.swift
//  ExProtocolOrientedCollectionView
//
//  Created by Kant on 12/16/23.
//

import UIKit

class PopularCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "AppleSDGothicNeo-Bold", size: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        backgroundColor = .blue
        titleLabel.backgroundColor = .red
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
        ])
    }
    
    func configure(withTitle title: String) {
        self.titleLabel.text = title
    }
}
