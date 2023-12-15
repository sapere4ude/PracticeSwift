//
//  MusicRecommendHeaderView.swift
//  ExProtocolOrientedCollectionView
//
//  Created by Kant on 12/15/23.
//

import Foundation
import UIKit

protocol MusicConfiguration: AnyObject {
    func configure(with viewModel: CellViewModelType?)
}

protocol MusicSectionConfiguration: AnyObject {
    func configure(with viewModel: SectionViewModelType?)
}

class MusicRecommendHeaderView: UICollectionReusableView, MusicSectionConfiguration {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "AppleSDGothicNeo-Bold", size: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: SectionViewModelType?) {
        guard let viewModel = viewModel as? MusicRecommendSectionViewModel else { return }
        titleLabel.text = viewModel.title
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
        ])
    }
}
