//
//  AdPlayer.swift
//  ExAdPlayer
//
//  Created by Kant on 2/9/24.
//

import UIKit
import AVFoundation

final class AdPlayer: UIView {

    enum State {
        case none
        case ready
        case playing
        case alreadyStarted
        case pause
    }
    
    // MARK: - Properties
    public var onTouch: (() -> Void)?
    public var onSkipped: (() -> Void)?
    public var onClose: (() -> Void)?
    public var onError: ((Error) -> Void)?
    public var onShow: (() -> Void)?
    
    // MARK: - Player
    /// 플레이어
    internal var player: AVPlayer
    /// 플레이어
    internal var playerLayer: AVPlayerLayer?
    ///
    internal let playerContext = UnsafeMutableRawPointer(bitPattern: 1)
    ///
    internal var playerItem: AVPlayerItem?
    ///
    internal var asset: AVAsset!
    ///
    internal var loadSeekTime: CMTime?
    /// 영상 광고 상태관리
    internal var state: State = .none
    internal let requiredAssetKeys = [
        "playable",
        "hasProtectedContent"
    ]
    
    // MARK: - Timeout Timer
    /// 영상 광고 타임아웃 타이머
    internal var timeoutTimer: Timer?
    /// 영상 광고 타임아웃 시간
    internal let timeoutInterval: TimeInterval = 2.0
    // MARK: - 남은 시간
    internal var currentVideoTime: Double = 0
    internal var remainingTimeToSkip: Double = 0
    /// 광고 영상 모델
    internal var model: AdModel?
    /// 영상 광고 URL
    internal var videoURL: URL?
    /// 영상 광고 확인을 위한 타임 옵저버
    internal var timeObserver: Any? // TODO: Notification 파일 안에서만 사용하므로 지역변수로 변경필요
    /// 시스템 정지 호출 플래그
    internal var pauseAction: Bool = false //함수호출을 통해 정지 (시스템에서 정지를 보낼경우를 비교하기 위함)
    /// 플레이어 실행 준비 플래그
    internal var readyToPlay: Bool = false
    /// 영상 광고 뒤로가기 버튼
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "btV1BackShadows", in: Bundle(identifier: "co.kr.Advertisement"), with: nil), for: .normal)
        //button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Back"
        return button
    }()
    /// 영상 광고 남은 시간
    lazy var playTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 10.0)
        label.textColor = .white
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 0, height: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        return label
    }()
    /// 영상 광고 터치 버튼
    lazy var touchButton: UIButton = {
        let touch = UIButton()
        touch.addTarget(self, action: #selector(didTapTouchButton), for: .touchUpInside)
        touch.setTitle("TOUCH", for: .normal)
        touch.titleLabel?.textColor = .white
        touch.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12.0)
        touch.backgroundColor = .black.withAlphaComponent(0.6)
        touch.translatesAutoresizingMaskIntoConstraints = false
        touch.isAccessibilityElement = true
        touch.accessibilityLabel = "Visit advertising site"
        return touch
    }()
    /// 영상 광고 스킵 버튼
    lazy var skipButton: UIButton = {
        let skip = UIButton()
        skip.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        skip.setTitle("SKIP AD", for: .normal)
        skip.setTitleColor(UIColor(named: "videoSkipButtonTitle", in: Bundle(identifier: "co.kr.Advertisement"), compatibleWith: nil), for: .normal)
        skip.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)
        skip.isHidden = true
        skip.translatesAutoresizingMaskIntoConstraints = false
        skip.isAccessibilityElement = true
        skip.accessibilityLabel = "skip advertising"
        return skip
    }()
    /// 영상 광고 스킵하기 표시
    lazy var remainingTimeToSkipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)
        label.textColor = .white
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        return label
    }()
    
    // MARK: - Initialize
    init(player: AVPlayer = AVPlayer()) {
        self.player = player
        super.init(frame: .zero)
        self.backgroundColor = .systemGreen
        //self.load(for: nil)
    }
    
    deinit {
        print("VideoAdPlayer Deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.playerLayer?.frame != self.bounds {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.playerLayer?.frame = self.bounds
            CATransaction.commit()
        }
    }
}
