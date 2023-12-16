//
//  CellViewModel.swift
//  ExProtocolOrientedCollectionView
//
//  Created by Kant on 12/16/23.
//

import UIKit


@objc protocol CellViewModel {
    var reuseIdentifier: String { get }
    var cellType: UICollectionViewCell.Type { get }
    func configure(cell: UICollectionViewCell)
}

class PopularCellViewModel: CellViewModel {
    
    static let cellReuseIdentifier = "PopularCell"
    
    var reuseIdentifier: String {
        return Self.cellReuseIdentifier
    }
    
    var cellType: UICollectionViewCell.Type {
        return PopularCell.self
    }
    
    func configure(cell: UICollectionViewCell) {
        guard let cell = cell as? PopularCell else { return }
        cell.configure(withTitle: "HAHA")
    }
}

class FeedCellViewModel: CellViewModel {
    
    static let cellReuseIdentifier = "FeedCell"
    
    var reuseIdentifier: String {
        return Self.cellReuseIdentifier
    }
    
    var cellType: UICollectionViewCell.Type {
        return FeedCell.self
    }
    
    func configure(cell: UICollectionViewCell) {
        guard let cell = cell as? FeedCell else { return }
        cell.configure(withTitle: "Feed 입니다")
    }
}
