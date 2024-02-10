//
//  SectionHeaderViewModel.swift
//  ExProtocolOrientedCollectionView
//
//  Created by Kant on 12/16/23.
//

import UIKit

@objc protocol SectionHeaderViewModelProtocol {
    var headerReuseIdentifier: String { get }
    var headerViewType: UICollectionReusableView.Type { get }
    func configure(headerView: UICollectionReusableView)
}

class PopularSectionHeaderViewModel: SectionHeaderViewModelProtocol {
    
    static let headerReuseIdentifier = "PopularSectionHeader"
    
    var headerReuseIdentifier: String {
        return Self.headerReuseIdentifier
    }
    
    var headerViewType: UICollectionReusableView.Type {
        return PopularSectionHeaderView.self
    }
    
    func configure(headerView: UICollectionReusableView) {
        guard let headerView = headerView as? PopularSectionHeaderView else { return }
        headerView.backgroundColor = .yellow
        headerView.configure(withTitle: "PopularSectionHeader")
    }
}

class FeedSectionHeaderViewModel: SectionHeaderViewModelProtocol {
    
    static let headerReuseIdentifier = "FeedSectionHeader"
    
    var headerReuseIdentifier: String {
        return Self.headerReuseIdentifier
    }
    
    var headerViewType: UICollectionReusableView.Type {
        return FeedSectionHeaderView.self
    }
    
    func configure(headerView: UICollectionReusableView) {
        guard let headerView = headerView as? FeedSectionHeaderView else { return }
        headerView.backgroundColor = .systemPink
        headerView.configure(withTitle: "FeedSectionHeader")
    }
}
