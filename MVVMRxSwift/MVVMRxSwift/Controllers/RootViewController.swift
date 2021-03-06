//
//  RootViewController.swift
//  MVVMRxSwift
//
//  Created by Kant on 2022/06/02.
//

import UIKit
import RxSwift
import RxRelay

class RootViewController: UIViewController {

    // MARK: Proprties
    let disposeBag = DisposeBag()
    let viewModel: RootViewModel
    
    private lazy var collectionView:UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        
        cv.backgroundColor = .systemBackground
        return cv
    }()
    
    private let articleViewModel = BehaviorRelay<[ArticleViewModel]>(value: []) // ~Relay 는 UI Event 에서 사용하기 적절하다
    var articleViewModelObsever: Observable<[ArticleViewModel]> {
        return articleViewModel.asObservable()
    }
    
    // MARK: LifeCycles
    init(viewModel: RootViewModel){ // <- 이런식으로 생성자로 만들어주는 이유 : RootViewController는 RootViewModel 에서 값만 가져오는 역할을 하기 위함. let viewModel = RootViewModel() 이런식으로 만들어주게 되면 VC와 분리되는 패턴을 가질 수 없기 때문
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureCollectionView()
        fetchArticles()
        subscribe()
    }
    
    // MARK: Configures
    func configureUI() {
        self.title = self.viewModel.title
        
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func configureCollectionView() {
        self.collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    // MARK: Helpers
    func fetchArticles() {
        viewModel.fetchArticles().subscribe(onNext: { articleViewModel in
            self.articleViewModel.accept(articleViewModel)
        }).disposed(by: disposeBag)
    }
    
    func subscribe() {
        self.articleViewModelObsever.subscribe(onNext: { articles in
            // collectionView reload
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }).disposed(by: disposeBag)
    }
}

extension RootViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articleViewModel.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArticleCell
        
        cell.imageView.image = nil
        
        let articleViewModel = self.articleViewModel.value[indexPath.row]
        cell.viewModel.onNext(articleViewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}
