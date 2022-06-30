//
//  PopupView.swift
//  ExCustomPopupView
//
//  Created by Kant on 2022/06/20.
//

import UIKit
import Foundation
import SnapKit
import AVKit

@objcMembers class PopupView: UIView {
    var isShow: Bool = false
    
    static var shared = PopupView()
    
    var titleText: String?
    var subTitleText: String?
    var accessText: String?
    var width: CGFloat?
    var height: CGFloat?
    var edgeSpace: CGFloat?
    var bottomSpace: CGFloat?
    var autoDismiss: Bool = true
    var autoDismissSeconds: Double = 2
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let vodPlayer: AVPlayer = {
        let vodPlayer = AVPlayer()
        return vodPlayer
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.text = "타이틀 타이틀 타이틀 타이틀 타이틀 타이틀"
        title.backgroundColor = .yellow
        return title
    }()
    
    let subTitle: UILabel = {
        let subTitle = UILabel()
        subTitle.text = "서브타이틀 서브타이틀 서브타이틀 서브타이틀 서브타이틀 서브타이틀"
        subTitle.backgroundColor = .blue
        return subTitle
    }()
    
    let exitBtn: UIButton = {
        let button = UIButton()
        button.setTitle("종료", for: .normal)
        button.backgroundColor = .cyan
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var VStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var HStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .green
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    // Player 관련
    private var playerLayer: AVPlayerLayer?
    
    let countLabel: UILabel = {
        let title = UILabel()
        title.text = "10:35"
        title.backgroundColor = .yellow
        return title
    }()
    
    let soundBtn: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemPink
        return button
    }()
    
    let vodEndTitle: UILabel = {
        let endTitle = UILabel()
        endTitle.text = "다음 부분 부터\n이어 보시겠습니까?"
        endTitle.backgroundColor = .systemPink
        return endTitle
    }()
    
    let watchVodBtn: UIButton = {
        let button = UIButton()
        button.setTitle("VOD 이어보기", for: .normal)
        return button
    }()
    
    private var dismissAction: (() -> Void)?
    private var tapAction: (() -> Void)?
    
    @objc private func dismiss() {
        dismiss {
            self.dismissAction?()
        }
    }
    
    @objc private func tap() {
        tapAction?()
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        print(#function)
        setupUI()
    }
    
    // MARK: - UI Setting
    private func setupUI() {
        dismiss(withDuration: 0, onComplete: nil)
        
        backgroundColor = .darkGray.withAlphaComponent(0.7)
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        addGestureRecognizer(dimmedTap)
        isUserInteractionEnabled = true
        
        self.addSubview(VStackView)
        VStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [HStackView, contentsView, subTitle].forEach {
            VStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [title, exitBtn].forEach {
            HStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        contentsView.addSubview(soundBtn)
        soundBtn.layer.zPosition = 10
        contentsView.addSubview(countLabel)
        countLabel.layer.zPosition = 10
        
        contentsView.addSubview(vodEndTitle)
        vodEndTitle.layer.zPosition = 10
        contentsView.addSubview(watchVodBtn)
        watchVodBtn.layer.zPosition = 10
        
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        soundBtn.translatesAutoresizingMaskIntoConstraints = false
        vodEndTitle.translatesAutoresizingMaskIntoConstraints = false
        watchVodBtn.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - setup Constraints
    private func setupConstraints(superView view: UIView) {
        print(#function)
        translatesAutoresizingMaskIntoConstraints = false
        
        // 이게 있어야 전체 뷰(bgView)의 위치가 잡아지면서, 위에 올라와 있는 뷰들도 자리가 잡힌다.
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: -view.frame.height),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // VStack
        NSLayoutConstraint.activate([
            VStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            VStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            VStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            VStackView.widthAnchor.constraint(equalTo: widthAnchor, constant: 0),
            VStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/2)
        ])
        
        // contentsView
        NSLayoutConstraint.activate([
            contentsView.leadingAnchor.constraint(equalTo: VStackView.leadingAnchor, constant: 0),
            contentsView.trailingAnchor.constraint(equalTo: VStackView.trailingAnchor, constant: 0),
            contentsView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // exitBtn
        NSLayoutConstraint.activate([
            exitBtn.trailingAnchor.constraint(equalTo: HStackView.trailingAnchor),
            exitBtn.widthAnchor.constraint(equalToConstant: 45),
            exitBtn.heightAnchor.constraint(equalToConstant: 45)
        ])
        exitBtn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        // HStack
        NSLayoutConstraint.activate([
            HStackView.leadingAnchor.constraint(equalTo: VStackView.leadingAnchor, constant: 0),
            HStackView.trailingAnchor.constraint(equalTo: VStackView.trailingAnchor, constant: 0),
            HStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // subTitle
        NSLayoutConstraint.activate([
            subTitle.leadingAnchor.constraint(equalTo: VStackView.leadingAnchor, constant: 0),
            subTitle.trailingAnchor.constraint(equalTo: VStackView.trailingAnchor, constant: 0),
            subTitle.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 20)
        ])
        
        // soundBtn
        NSLayoutConstraint.activate([
            soundBtn.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 20),
            soundBtn.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -20),
            soundBtn.widthAnchor.constraint(equalToConstant: 45),
            soundBtn.heightAnchor.constraint(equalToConstant: 45),
        ])
        
        // countLabel
        NSLayoutConstraint.activate([
            countLabel.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -20),
            countLabel.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: -20),
            countLabel.widthAnchor.constraint(equalToConstant: 45),
            countLabel.heightAnchor.constraint(equalToConstant: 45),
        ])
        
        // vodEndTitle
        NSLayoutConstraint.activate([
            vodEndTitle.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
            vodEndTitle.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor)
        ])
        
        // watchVodBtn
        NSLayoutConstraint.activate([
            watchVodBtn.centerXAnchor.constraint(equalTo: contentsView.centerXAnchor),
            watchVodBtn.centerYAnchor.constraint(equalTo: contentsView.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        print(#function)
        super.layoutSubviews()
        
        self.playerLayer?.frame = self.contentsView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - show & hide, pan gesture
    func show(vc: UIViewController, withDuration duration: Double = 1.5, onTapAction: (() -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        tapAction = onTapAction
        dismissAction = onDismiss
        self.autoDismiss = true
        self.autoDismissSeconds = 2
        
        guard duration != 0 else {
            alpha = 1
            isHidden = false
            return
        }
        
        vc.view.addSubview(self) // <- 이 코드가 실행되면 init(frame:CGRect) 함수가 실행된다. 그렇게 frame 을 설정해주고 아랫줄로 넘어가게된다.
        setupConstraints(superView: vc.view)
        
        self.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: duration) { [weak self] in
            self?.alpha = 1
            self?.isHidden = false
            self?.transform = .init(translationX: 0, y: 0)
        } completion: { _ in
            guard self.autoDismiss else {
                return
            }
            self.isShow = true
            
            self.contentsView.translatesAutoresizingMaskIntoConstraints = false
            let item = AVPlayerItem(url: URL(string: "https://vod-archive-kr-cdn-z01.afreecatv.com/v101/video/_definst_/smil:vod/20220628/440/241364440/REGL_C0F9F1C9_241364440_9.smil/playlist.m3u8")!)
            self.vodPlayer.replaceCurrentItem(with: item)
            let playerLayer = AVPlayerLayer(player: self.vodPlayer)
            playerLayer.frame = self.contentsView.bounds
            playerLayer.videoGravity = .resizeAspectFill
            self.playerLayer = playerLayer
            self.contentsView.layer.addSublayer(playerLayer)
            self.vodPlayer.play()
        }
    }
    
    @objc func dismiss(withDuration duration: Double = 1.5, onComplete: (() -> Void)? = nil) {
        guard duration != 0 else {
            alpha = 0
            isHidden = true
            onComplete?()
            return
        }
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.alpha = 0
            self.transform = .init(translationX: 0, y: UIScreen.main.bounds.height)
        } completion: { [weak self] _ in
            self?.isHidden = true
            self?.isShow = false
            onComplete?()
        }
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        dismiss()
    }
}



