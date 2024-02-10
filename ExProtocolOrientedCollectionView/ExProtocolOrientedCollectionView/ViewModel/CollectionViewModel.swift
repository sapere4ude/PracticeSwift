//
//  CollectionViewModel.swift
//  ExProtocolOrientedCollectionView
//
//  Created by Kant on 12/16/23.
//

import UIKit

@objc protocol CollectionViewModelProtocol: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var cellViewModels: [[CellViewModelProtocol]] { get }
    var numberOfSections: Int { get }
    func numberOfItems(inSection section: Int) -> Int
    func cellViewModel(at indexPath: IndexPath) -> CellViewModelProtocol
    func sectionHeaderViewModel(forSection section: Int) -> SectionHeaderViewModelProtocol?
    func registerCells(for collectionView: UICollectionView)
    func registerHeaders(for collectionView: UICollectionView)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    func numberOfSections(in collectionView: UICollectionView) -> Int
}

class BaseCollectionViewModel: NSObject, CollectionViewModelProtocol {

    var cellViewModels: [[CellViewModelProtocol]] {
        return [popularCellViewModels, feedCellViewModels]
    }
    
    private let popularCellViewModels: [CellViewModelProtocol] = [PopularCellViewModel(), PopularCellViewModel(), PopularCellViewModel()]

    private let feedCellViewModels: [CellViewModelProtocol] = [FeedCellViewModel()]

    private let sectionHeaderViewModels: [SectionHeaderViewModelProtocol?] = [
        PopularSectionHeaderViewModel(),
        FeedSectionHeaderViewModel(),
        FeedSectionHeaderViewModel(),
    ]

    var numberOfItems: Int {
        return cellViewModels.reduce(0) { $0 + $1.count }
    }

    func cellViewModel(at indexPath: IndexPath) -> CellViewModelProtocol {
        switch indexPath.section {
        case 0:
            return popularCellViewModels[indexPath.item]
        case 1:
            return feedCellViewModels[indexPath.item]
        default:
            fatalError("Invalid section")
        }
    }

    var numberOfSections: Int {
        return sectionHeaderViewModels.count
    }

    func numberOfItems(inSection section: Int) -> Int {
        switch section {
        case 0:
            return popularCellViewModels.count
        case 1:
            return feedCellViewModels.count
        default:
            return 0
        }
    }

    func sectionHeaderViewModel(forSection section: Int) -> SectionHeaderViewModelProtocol? {
        return sectionHeaderViewModels[section]
    }
    
    func registerCells(for collectionView: UICollectionView) {
        cellViewModels.flatMap { $0 }.forEach { viewModel in
            if let viewModel = viewModel as? PopularCellViewModel {
                collectionView.register(viewModel.cellType, forCellWithReuseIdentifier: viewModel.reuseIdentifier)
            } else if let viewModel = viewModel as? FeedCellViewModel {
                collectionView.register(viewModel.cellType, forCellWithReuseIdentifier: viewModel.reuseIdentifier)
            }
        }
    }
    
    func registerHeaders(for collectionView: UICollectionView) {
        sectionHeaderViewModels.compactMap { $0 }.forEach { viewModel in
            collectionView.register(viewModel.headerViewType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: viewModel.headerReuseIdentifier)
        }
    }
}

// MARK: Cell
extension BaseCollectionViewModel {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = cellViewModel(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.reuseIdentifier, for: indexPath)
        cellViewModel.configure(cell: cell)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}

// MARK: Header
extension BaseCollectionViewModel {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader,
           let headerViewModel = sectionHeaderViewModel(forSection: indexPath.section) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewModel.headerReuseIdentifier, for: indexPath)
            headerViewModel.configure(headerView: headerView)
            return headerView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let headerViewModel = sectionHeaderViewModel(forSection: section) {
            return CGSize(width: collectionView.frame.width, height: 70)
        }
        return CGSize.zero
    }
}

