//
//  ViewController.swift
//  ExProtocolOrientedCollectionView
//
//  Created by Kant on 12/15/23.
//

import UIKit

class ViewController: UIViewController {

    var collectionView: UICollectionView?
    var collectionViewModel: CollectionViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewModel = BaseCollectionViewModel()
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        collectionViewModel?.registerHeaders(for: collectionView)
        collectionViewModel?.registerCells(for: collectionView)

        collectionView.dataSource = collectionViewModel
        collectionView.delegate = collectionViewModel

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
