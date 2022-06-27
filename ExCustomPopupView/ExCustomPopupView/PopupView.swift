//
//  PopupView.swift
//  ExCustomPopupView
//
//  Created by Kant on 2022/06/20.
//

import UIKit
import SnapKit
@objcMembers class PopupView: UIView {

    enum TabBarUpperMode {
        case expire
        case join
        case gift
    }
    
    var isShow: Bool = false
    
    static var shared = PopupView()
    
    var tabBarUpperMode: TabBarUpperMode = .gift
    var titleText: String?
    var subTitleText: String?
    var accessText: String?
    var width: CGFloat = 382
    var height: CGFloat = 150
    var edgeSpace: CGFloat = 16
    var bottomSpace: CGFloat = 20
//    var borderWidth: CGFloat = 1.5
    var bgColor: UIColor = .init(red: 225.0 / 255, green: 244.0 / 255, blue: 205.0 / 255, alpha: 1)
//    var borderColor: CGColor = .init(red: 138.0 / 255, green: 211.0 / 255, blue: 58.0 / 255, alpha: 1)
    var autoDismiss: Bool = true
    var autoDismissSeconds: Double = 2
    
    let thumbnailImageView: UIImageView = {
            let thumbnail = UIImageView()
            thumbnail.layer.cornerRadius = 6
            thumbnail.layer.masksToBounds = true
            thumbnail.contentMode = .scaleToFill
//            thumbnail.image = UIImage.imageStyle(named: "default_thumbnail_normal")
            thumbnail.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
            thumbnail.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
            thumbnail.setContentHuggingPriority(.defaultLow, for: .horizontal)
            return thumbnail
        }()

    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = titleText
        title.backgroundColor = .yellow
        title.font = UIFont.systemFont(ofSize: 16)
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        return title
    }()

    lazy var subTitleLabel: UILabel = {
        let title = UILabel()
        title.text = subTitleText
        title.backgroundColor = .yellow
        title.font = UIFont.systemFont(ofSize: 16)
        title.numberOfLines = 2
        title.lineBreakMode = .byTruncatingTail
        return title
    }()

    lazy var cancelButton: UIButton = {
        let more = UIButton()
        more.setTitle("취소", for: .normal)
        more.backgroundColor = .green
        more.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return more
    }()

    lazy var joinButton: UIButton = {
        let more = UIButton()
        more.setTitle(accessText, for: .normal)
        more.backgroundColor = .red
        more.addTarget(self, action: #selector(accessBtnClick), for: .touchUpInside)
        return more
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
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    
        
    }
    
    override func awakeFromNib() {
        super .awakeFromNib()
        
    }
    
    @objc private func accessBtnClick() {
//        if tabBarUpperMode == .gift {
//            var adballoonUrl = "https://m.afreecatv.com/adballoon/a/myadballoon"
//            if let adballoonUrlWithIDFA : String = AFDeviceInfo.addIDFA(adballoonUrl) {
//                adballoonUrl = adballoonUrlWithIDFA
//            }
//
//            let adballoonUrlEscaped = adballoonUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//            let scheme = "afreeca://browser/station?url=\(adballoonUrlEscaped)"
//            let logParam = [
//                "code_type" : "myinfo_icon",
//                "button_type" : "adballoon"
//            ]
//            AFLogCollectorManager.shared()?.send(AFLogType_CLICK, info: logParam)
//            AFActivityManager.shared()?.activityStartPlayer(scheme)
//        } else if tabBarUpperMode == .join {
//
//        } else if tabBarUpperMode == .expire {
//
//        }
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
//        view.addSubview(self)
//        setupConstraints(superView: self)
        
        backgroundColor = self.bgColor
//        layer.borderWidth = 1.5
//        layer.borderColor = self.borderColor
        layer.cornerRadius = 12
        clipsToBounds = true
        
        dismiss(withDuration: 0, onComplete: nil)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        
        if tabBarUpperMode == .gift {
            titleText = "아직 못 본 나중에 보기가 있어요!"
            subTitleText = "릴카 사라진 2021년 마지막 라디오인 신청곡 받아요 어서오세요~"
            accessText = "참여하기"
        } else if tabBarUpperMode == .expire {
            titleText = "12개의 애드벌룬이 7일 뒤 소멸됩니다."
            subTitleText = "가장 많이 모은 BJ의 VOD에 선물해보세요!"
            accessText = "선물하기"
        } else if tabBarUpperMode == .join {
            
        }
        
        self.addSubview(thumbnailImageView)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
//        thumbnailImageView.size(width: 100)

        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: self.thumbnailImageView.trailingAnchor, constant: 9).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

        self.addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.leadingAnchor.constraint(equalTo: self.thumbnailImageView.trailingAnchor, constant: 9).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        subTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subTitleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

        self.addSubview(joinButton)
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        joinButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        joinButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        joinButton.widthAnchor.constraint(equalToConstant: 32).isActive = true

        self.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.joinButton.leadingAnchor, constant: -25).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        // MARK: - gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - setup Constraints
    private func setupConstraints(superView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -(self.edgeSpace * 2)).isActive = true
        let widthConstraint = widthAnchor.constraint(equalToConstant: self.width)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        heightAnchor.constraint(equalToConstant: self.height).isActive = true
        
        let leadingConstraint = leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: self.edgeSpace)
        leadingConstraint.priority = .defaultHigh
        leadingConstraint.isActive = true
        
        let trailingConstraint = trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -self.edgeSpace)
        trailingConstraint.priority = .defaultHigh
        trailingConstraint.isActive = true
        
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -self.bottomSpace).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - show & hide, pan gesture
    func show(vc: UIViewController, withDuration duration: Double = 0.3, onTapAction: (() -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        tapAction = onTapAction
        dismissAction = onDismiss

        self.width = 382
        self.height = 150
        self.edgeSpace = 16
        self.bottomSpace = 20
        self.layer.borderWidth = 1.5
        self.bgColor = .init(red: 225.0 / 255, green: 244.0 / 255, blue: 205.0 / 255, alpha: 1)
        self.layer.borderColor = .init(red: 138.0 / 255, green: 211.0 / 255, blue: 58.0 / 255, alpha: 1)
        self.autoDismiss = true
        self.autoDismissSeconds = 2
        
        guard duration != 0 else {
            alpha = 1
            isHidden = false
            return
        }
        
        vc.view.addSubview(self)
        setupConstraints(superView: vc.view)

        guard self.isShow == false else { return }
        
//        if Double.random(in: 0.0...100.0) < 45.0 {
            self.transform = .init(translationX: 0, y: self.bottomSpace)
            UIView.animate(withDuration: duration) { [weak self] in
                self?.alpha = 1
                self?.isHidden = false
                self?.transform = .init(translationX: 0, y: 0)
            } completion: { _ in
                guard self.autoDismiss else {
                    return
                }
                self.isShow = true
            }
//        }
    }
    
    @objc func dismiss(withDuration duration: Double = 0.3, onComplete: (() -> Void)? = nil) {
        guard duration != 0 else {
            alpha = 0
            isHidden = true
            onComplete?()
            return
        }
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.alpha = 0
            self.transform = .init(translationX: 0, y: self.bottomSpace)
        } completion: { [weak self] _ in
            self?.isHidden = true
            self?.isShow = false
            onComplete?()
        }
    }

    func keyboardWillShow(notification: Notification) {
        
    }
    
    func keyboardWillHide(notification: Notification) {
        self.removeFromSuperview()
    }
    
    @objc func respondToPanGesture(_ gesture: UIPanGestureRecognizer) {
           let viewTranslation = gesture.translation(in: self)
           let viewVelocity = gesture.velocity(in: self)
           
           switch gesture.state {
           case .changed:
               if abs(viewVelocity.y) > abs(viewVelocity.x) {
                   if viewVelocity.y > 0 {
//                       UIView.animate(withDuration: 0.5) {
                           self.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
//                       }
                   }
               }
           case .ended:
               if viewTranslation.y < self.height/2 {
//                   UIView.animate(withDuration: 0.5) {
                       self.transform = .identity
//                   }
               } else {
                   dismiss()
               }
           default:
               break
           }
       }
}



