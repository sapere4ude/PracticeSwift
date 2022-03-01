//
//  ViewController.swift
//  SafeAreaLab
//
//  Created by Kant on 2022/03/01.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        let topLabel = makeLabel(withText: "top")
        let bottomLabel = makeLabel(withText: "bottom")

        let leadingLabel = makeLabel(withText: "leading")
        let trailingLabel = makeLabel(withText: "trailing")

        view.addSubview(topLabel)
        view.addSubview(bottomLabel)
        view.addSubview(leadingLabel)
        view.addSubview(trailingLabel)

        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Challenge: Add a bottom label
            bottomLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            bottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // leading & trailing 에 safeAreaLayoutGuide 적용하려해도 안된다는 사실을 볼 수 있음.
            // safeAreaLayoutGuide 는 top, bottom 에만 적용되는 것
            leadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trailingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trailingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func makeLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.backgroundColor = .yellow
        label.font = .systemFont(ofSize: 32)
        return label
    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//    }
//
//    func setupViews() {
//        let redView = UIView()
//        redView.translatesAutoresizingMaskIntoConstraints = false
//        redView.backgroundColor = .red
//
//        view.addSubview(redView)
//
//        NSLayoutConstraint.activate([
//            redView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            redView.leadingAnchor.constrai nt(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            redView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            redView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//        ])
//    }
}

