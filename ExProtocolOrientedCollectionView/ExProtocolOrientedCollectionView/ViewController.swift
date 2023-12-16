//
//  ViewController.swift
//  ExProtocolOrientedCollectionView
//
//  Created by Kant on 12/15/23.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var collectionViewModel: CollectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewModel = BaseCollectionViewModel()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        // Create UICollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // Register Cells
        collectionViewModel.registerHeaders(for: collectionView)
        collectionViewModel.registerCells(for: collectionView)
        
        // Set dataSource and delegate
        collectionView.dataSource = collectionViewModel
        collectionView.delegate = collectionViewModel
        
        // Add constraints for collectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
