//
//  ViewController.swift
//  ExCustomPublisher
//
//  Created by kant on 2022/12/19.
//

import UIKit
import Combine
import SnapKit

class ViewController: UIViewController {
    
    //  @IBOutlet weak var centerButton: UIButton!
    //  @IBOutlet weak var centerLabel: UILabel!
    private var cancellables = Set<AnyCancellable>()
    private var buttonTapCount = 0
    private var labelTapCount = 0
    
    private var centerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        return button
    }()
    
    private var centerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .yellow
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubViews()
        configureUI()

        centerButton.throttleTapPublisher()
            .receive(on: RunLoop.main)
            .map { [weak self] _ in
                self?.buttonTapCount += 1
                return "throttleTap count : \(self?.buttonTapCount ?? 0)"
            }
            .sink { [weak self] title in
                self?.centerButton.setTitle(title, for: .normal)
            }
            .store(in: &cancellables)
        
        centerLabel.isUserInteractionEnabled = true
        centerLabel.throttleTapGesturePublisher()
            .receive(on: RunLoop.main)
            .map { [weak self] _ in
                self?.labelTapCount += 1
                return "throttleTap count : \(self?.labelTapCount ?? 0)"
            }
            .assign(to: \.text, on: centerLabel)
            .store(in: &cancellables)
    }
    
    func configureUI() {
        centerButton.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(70)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-200)
        }
        
        centerLabel.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(70)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(200)
        }
    }
    
    func configureSubViews() {
        view.addSubview(centerButton)
        view.addSubview(centerLabel)
    }
}
