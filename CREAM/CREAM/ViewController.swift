//
//  ViewController.swift
//  CREAM
//
//  Created by Kant on 2022/05/04.
//

import UIKit

class ViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: Self.getLayout())
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.scrollIndicatorInsets = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 4)
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(AdvertisementCell.self, forCellWithReuseIdentifier: "AdvertisementCell")
//        view.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
//        view.register(HeaderCollectionSecondReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionSecondReusableView.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static func getLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                let itemFractionalWidthFraction = 1.0 / 3.0 // horizontal 3개의 셀
                let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
                let itemInset: CGFloat = 2.5
                
                
                // Item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(itemFractionalWidthFraction),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                // Group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(groupFractionalHeightFraction)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                
//                section.orthogonalScrollingBehavior = .groupPaging
                
                section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                              heightDimension: .absolute(50.0))
                
                // 이 부분을 통해 viewForSupplementaryElementOfKind 메소드를 호출할 수 있음
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [header]
                
                return section
            default:
                let itemFractionalWidthFraction = 1.0 / 5.0 // horizontal 5개의 셀
                let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
                let itemInset: CGFloat = 2.5
                
                // Item
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(itemFractionalWidthFraction),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                // Group
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(groupFractionalHeightFraction)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // Section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                              heightDimension: .absolute(50.0))
                
                // 이 부분을 통해 viewForSupplementaryElementOfKind 메소드를 호출할 수 있음
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch self.dataSource[section] {
//        case let .first(items):
//            return items.count
//        case let .second(items):
//            return items.count
//        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertisementCell", for: indexPath) as! AdvertisementCell
        cell.backgroundColor = .blue
//        switch self.dataSource[indexPath.section] {
//        case let .first(items):
//            cell.prepare(text: items[indexPath.item].value)
//        case let .second(items):
//            cell.prepare(text: items[indexPath.item].value)
//        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch self.dataSource[indexPath.section] {
//        case let .first(items):
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
//            header.configure()
//            return header
//        case let .second(items):
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionSecondReusableView.identifier, for: indexPath) as! HeaderCollectionSecondReusableView
//            header.configure()
//            return header
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 200)
    }
}

