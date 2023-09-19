//
//  ProfileViewController.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/11/13.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxGesture
import MessageUI
import FirebaseAuth
import KakaoSDKUser
import KakaoSDKAuth
final class ProfileViewController: UIViewController, UIImagePickerControllerDelegate {
    private var allComponents                   = [UIView()]
    
    private let mainProfile                     = UIView()
    private let settingBtn                      = UIButton()
    private let mainProfileImageView            = UIImageView()
    private let mainProfileImageIndicator       = UIActivityIndicatorView()
    private let mainProfileImgCameraBtn         = UIButton()
    private let mainProfileImgGrayTint          = UIImageView()
    
    private let mainProfileTag                  = MainLabel(type: .small3)
    private let userNickName                    = UITextField()
    private let userNickNameModifyBtn           = UIButton()
    private let logOutLabel                     = MainLabel(type: .Basics2)
    private let withdrawalButton                = MainLabel(type: .Basics2)
    private let followingCount                  = MainLabel(type: .Big2)
    private let followingLabel                  = MainLabel(type: .Basics2)
    private let mainProfileDivideBar            = UIView()
    private let followerCount                   = MainLabel(type: .Big2)
    private let followerLabel                   = MainLabel(type: .Basics2)
    
    private let retrenchView                    = UIView()
    private let retrenchCO2Label                = MainLabel(type: .Basics2)
    private let retrenchDeliveryFeeLabel        = MainLabel(type: .Basics2)
    
    private let retrenchViewDivideHorizontal    = UIView()
    
    private let retrenchCO2Value                = MainLabel(type: .Big1)
    private let retrenchCO2Gram                 = MainLabel(type: .Basics2)
    private let retrenchViewDivideVertical      = UIView()
    private let retrenchDeliveryFeeValue        = MainLabel(type: .Big1)
    private let retrenchDeliveryFeeWon          = MainLabel(type: .Basics2)
    
    private let seeMyOrderHistoryButton         = UIButton()
    private let seeMyReviewsButton              = UIButton()
    private let serviceCenterButton             = UIButton()
    private let changeDefaultAddressButton      = UIButton()
    
    private var viewModel : ProfileBusinessLogic?
    private var disposeBag                      = DisposeBag()
    private var beforeProfile : ModifyProfileModel?
    private var isImageChanged                  = false

    override func viewDidLoad() {
        super.viewDidLoad()

        putAllComponentsToAlphaValue()
        setUp()
        setAttribute()
        addView()
        setLayout()
        addAction()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        bindProfile()
    }
    private func putAllComponentsToAlphaValue() {
        allComponents.append(mainProfile)
        allComponents.append(mainProfileImageView)
        allComponents.append(retrenchView)
        allComponents.append(seeMyOrderHistoryButton)
        allComponents.append(seeMyReviewsButton)
        allComponents.append(logOutLabel)
        allComponents.append(withdrawalButton)
        allComponents.append(serviceCenterButton)
        allComponents.append(changeDefaultAddressButton)
        allComponents.append(followingCount)
        allComponents.append(followingLabel)
        allComponents.append(mainProfileDivideBar)
        allComponents.append(followerCount)
        allComponents.append(followerLabel)
        allComponents.append(retrenchCO2Label)
        allComponents.append(retrenchDeliveryFeeLabel)
        allComponents.append(retrenchViewDivideHorizontal)
        allComponents.append(retrenchCO2Value)
        allComponents.append(retrenchCO2Gram)
        allComponents.append(retrenchViewDivideVertical)
        allComponents.append(retrenchDeliveryFeeValue)
        allComponents.append(retrenchDeliveryFeeWon)
    }
    
    private func setUp() {
        self.viewModel = ProfileViewModel()
        userNickName.delegate = self
    }
    
    private func setAttribute() {
        view.backgroundColor = .viewBackgroundGray
        
        mainProfile.do {
            $0.borderColor = .mainYellow
            $0.borderWidth = 3
            $0.backgroundColor = .white
            $0.cornerRadius = 14
        }
        
        settingBtn.do {
            $0.setImage(UIImage(named: "설정.png"), for: .normal)
            $0.setImage(UIImage(named: "설정누름.png"), for: .selected)
            $0.setImage(UIImage(named: "설정누름.png"), for: .highlighted)
        }
        
        mainProfileImageView.do {
            $0.backgroundColor = .white
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 53.5
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.clear.cgColor
        }
        
        mainProfileImageIndicator.do {
            $0.color = .mainOrange1
        }
        
        mainProfileImgCameraBtn.do {
            $0.setImage(UIImage(named: "카메라.png"), for: .normal)
            $0.alpha = 0
        }
        
        mainProfileImgGrayTint.do {
            $0.image = UIImage(named: "Ellipse 112.png")
            $0.alpha = 0
        }
        
        mainProfileTag.do {
            $0.text = "디바이드 공식 돼지"
            $0.textAlignment = .center
            $0.textColor = .mainOrange1
        }
        
        userNickName.do {
            $0.textAlignment = .center
            $0.text = "룡룡"
            $0.textColor = .black
            $0.isEnabled = false
        }
        
        userNickNameModifyBtn.do {
            $0.setImage(UIImage(named: "글쓰기.png"), for: .normal)
            $0.alpha = 0
        }
        
        logOutLabel.do {
            $0.text = "로그아웃"
            $0.textColor = .black
            $0.cornerRadius = 10
            $0.borderColor = .mainOrange2
            $0.borderWidth = 1
            $0.textAlignment = .center
        }
        
        withdrawalButton.do {
            $0.text = "회원탈퇴"
            $0.textColor = .black
            $0.cornerRadius = 10
            $0.borderColor = .mainOrange2
            $0.borderWidth = 1
            $0.textAlignment = .center
        }
        followingCount.do {
            $0.textAlignment = .center
            $0.text = "0"
        }
        
        followingLabel.do {
            $0.textAlignment = .center
            $0.text = "팔로잉"
        }
        
        mainProfileDivideBar.do {
            $0.backgroundColor = .gray0
        }
        
        followerCount.do {
            $0.textAlignment = .center
            $0.text = "0"
        }
        
        followerLabel.do {
            $0.textAlignment = .center
            $0.text = "팔로워"
        }
        
        retrenchView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 26
//            $0.layer.addShadow(location: .all, color: .gray, opacity: 0.1, radius: 26)
        }
        
        retrenchCO2Label.do {
            $0.text = "절약한 탄소배출"
            $0.textAlignment = .center
        }
        
        retrenchDeliveryFeeLabel.do {
            $0.text = "절약한 배달비"
            $0.textAlignment = .center
        }
        
        retrenchViewDivideHorizontal.do {
            $0.backgroundColor = .gray0
        }
        
        retrenchCO2Value.do {
            $0.text = "0"
            $0.textColor = .mainOrange1
            $0.textAlignment = .right
        }
        
        retrenchCO2Gram.do {
            $0.text = "g"
            $0.textColor = .mainOrange2
        }
        
        retrenchViewDivideVertical.do {
            $0.backgroundColor = .gray0
        }
        
        retrenchDeliveryFeeValue.do {
            $0.text = "0"
            $0.textColor = .mainOrange1
            $0.textAlignment = .right
        }
        
        retrenchDeliveryFeeWon.do {
            $0.text = "원"
            $0.textColor = .mainOrange2
        }
        
        seeMyOrderHistoryButton.do {
            $0.setTitle("나의 주문내역 보기", for: .normal)
            $0.setTitleColor(.mainOrange1, for: .normal)
            $0.backgroundColor = .white
            $0.titleLabel?.font = .NotoSansKR(.bold, size: 14)
            
            $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .mainOrange1
            $0.semanticContentAttribute = .forceRightToLeft
            $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -160)

            $0.configuration?.titleAlignment = .center
            $0.layer.cornerRadius = 23.5
            $0.layer.addShadow(location: .all, color: .gray, opacity: 0.1, radius: 23.5)
        }
        
        seeMyReviewsButton.do {
            $0.setTitle("내가 쓴 리뷰 보기", for: .normal)
            $0.setTitleColor(.mainOrange1, for: .normal)
            $0.backgroundColor = .white
            $0.titleLabel?.font = .NotoSansKR(.bold, size: 14)
            
            $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .mainOrange1
            $0.semanticContentAttribute = .forceRightToLeft
            $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -165)

            
            $0.configuration?.titleAlignment = .center
            $0.layer.cornerRadius = 23.5
            $0.layer.addShadow(location: .all, color: .gray, opacity: 0.1, radius: 23.5)
        }
        
        serviceCenterButton.do {
            $0.setTitle("문의 사항", for: .normal)
            $0.setTitleColor(.mainOrange1, for: .normal)
            $0.backgroundColor = .white
            $0.titleLabel?.font = .NotoSansKR(.bold, size: 14)
            
            $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .mainOrange1
            $0.semanticContentAttribute = .forceRightToLeft
            $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -210)

            
            $0.configuration?.titleAlignment = .center
            $0.layer.cornerRadius = 23.5
            $0.layer.addShadow(location: .all, color: .gray, opacity: 0.1, radius: 23.5)
        }
        
        changeDefaultAddressButton.do {
            $0.setTitle("기본 주소지 변경", for: .normal)
            $0.setTitleColor(.mainOrange1, for: .normal)
            $0.backgroundColor = .white
            $0.titleLabel?.font = .NotoSansKR(.bold, size: 14)
            
            $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .mainOrange1
            $0.semanticContentAttribute = .forceRightToLeft
            $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: -165)

            
            $0.configuration?.titleAlignment = .center
            $0.layer.cornerRadius = 23.5
            $0.layer.addShadow(location: .all, color: .gray, opacity: 0.1, radius: 23.5)
        }
    }
    private func addView() {
        view.addSubview(mainProfile)
        view.addSubview(withdrawalButton)
        view.addSubview(mainProfileImageView)
        view.addSubview(mainProfileImageIndicator)
        view.addSubview(mainProfileImgGrayTint)
        view.addSubview(mainProfileImgCameraBtn)

        view.addSubview(userNickName)
        view.addSubview(userNickNameModifyBtn)
        view.addSubview(logOutLabel)
        view.addSubview(retrenchView)
        view.addSubview(seeMyOrderHistoryButton)
        view.addSubview(seeMyReviewsButton)
        view.addSubview(serviceCenterButton)
        view.addSubview(changeDefaultAddressButton)
        
        mainProfile.addSubviews([mainProfileTag,
                                 followingCount, followingLabel, mainProfileDivideBar, followerCount, followerLabel, settingBtn])
        
        retrenchView.addSubviews([retrenchCO2Label, retrenchDeliveryFeeLabel, retrenchViewDivideHorizontal, retrenchCO2Value, retrenchCO2Gram, retrenchViewDivideVertical, retrenchDeliveryFeeValue, retrenchDeliveryFeeWon])
    }
    func setLayout() {
        let widthBase = UIScreen.main.bounds.width * 0.85
        mainProfile.snp.makeConstraints {
            $0.width.equalTo(widthBase)
            $0.height.equalTo(167)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(110)
        }
        
        settingBtn.snp.makeConstraints {
            $0.width.height.equalTo(23)
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        mainProfileImageView.snp.makeConstraints {
            $0.width.equalTo(107)
            $0.height.equalTo(107)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainProfile).offset(-53.5)
        }
        
        mainProfileImageIndicator.snp.makeConstraints {
            $0.width.height.equalTo(mainProfileImageView)
            $0.center.equalTo(mainProfileImageView)
        }
        
        mainProfileImgCameraBtn.snp.makeConstraints {
            $0.center.equalTo(mainProfileImageView)
            $0.width.equalTo(33)
            $0.height.equalTo(27)
        }
        
        mainProfileImgGrayTint.snp.makeConstraints {
            $0.width.height.equalTo(mainProfileImageView)
            $0.center.equalTo(mainProfileImageView)
        }
        
        mainProfileTag.snp.makeConstraints {
            $0.width.equalTo(84)
            $0.height.equalTo(14)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-15)
        }
        
        userNickName.snp.makeConstraints {
            $0.leading.trailing.equalTo(mainProfile)
            $0.height.equalTo(23)
            $0.centerX.equalTo(mainProfile)
            $0.centerY.equalTo(mainProfile)
        }
        
        userNickNameModifyBtn.snp.makeConstraints {
            $0.width.equalTo(23)
            $0.height.equalTo(26)
            $0.leading.equalTo(userNickName.snp.trailing).offset(-10)
            $0.bottom.equalTo(userNickName.snp.bottom)
        }
        
        logOutLabel.snp.makeConstraints {
            $0.leading.equalTo(mainProfile).offset(10)
            $0.height.equalTo(20)
            $0.trailing.equalTo(mainProfileImageView.snp.leading).offset(-5)
            $0.bottom.equalTo(mainProfile.snp.top).offset(-10)
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.leading.equalTo(mainProfileImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(mainProfile.snp.trailing).offset(-5)
            $0.bottom.equalTo(mainProfile.snp.top).offset(-10)
        }
        
        followingCount.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(29)
            $0.leading.equalToSuperview().offset(76.5)
            $0.centerY.equalToSuperview().offset(20)
        }
        
        followingLabel.snp.makeConstraints {
            $0.width.equalTo(35)
            $0.height.equalTo(16)
            $0.centerY.equalToSuperview().offset(45)
            $0.leading.equalToSuperview().offset(65)
        }
        
        mainProfileDivideBar.snp.makeConstraints {
            $0.width.equalTo(3)
            $0.height.equalTo(34)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(35)
        }
        
        followerCount.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(29)
            $0.trailing.equalToSuperview().offset(-76.5)
            $0.centerY.equalToSuperview().offset(20)
        }
        
        followerLabel.snp.makeConstraints {
            $0.width.equalTo(35)
            $0.height.equalTo(16)
            $0.centerY.equalToSuperview().offset(45)
            $0.trailing.equalToSuperview().offset(-65)
        }
        
        retrenchView.snp.makeConstraints {
            $0.width.equalTo(mainProfile)
            $0.height.equalTo(132)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(mainProfile).offset(166)
        }
        
        retrenchCO2Label.snp.makeConstraints {
            $0.trailing.equalTo(retrenchView.snp.centerX).offset(-10)
            $0.height.equalTo(17)
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(25)
        }
        
        retrenchDeliveryFeeLabel.snp.makeConstraints {
            $0.leading.equalTo(retrenchView.snp.centerX).offset(10)
            $0.height.equalTo(17)
            $0.trailing.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(25)
        }
        
        retrenchViewDivideHorizontal.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(2)
            $0.centerY.equalToSuperview().offset(-5)
        }
        
        retrenchViewDivideVertical.snp.makeConstraints {
            $0.width.equalTo(2)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(retrenchViewDivideHorizontal.snp.bottom).offset(10)
        }
        
        retrenchCO2Gram.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(18)
            $0.bottom.equalTo(retrenchViewDivideVertical)
            $0.trailing.equalTo(retrenchViewDivideVertical).offset(-20)
        }
        
        retrenchCO2Value.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(32)
            $0.bottom.equalTo(retrenchCO2Gram)
            $0.trailing.equalTo(retrenchCO2Gram.snp.leading).offset(-10)
        }
        
        
        retrenchDeliveryFeeValue.snp.makeConstraints {
            $0.leading.equalTo(retrenchViewDivideVertical.snp.trailing).offset(10)
            $0.height.equalTo(32)
            $0.top.equalTo(retrenchCO2Value)
            $0.trailing.equalTo(retrenchDeliveryFeeWon.snp.leading).offset(-10)
            
        }
        
        retrenchDeliveryFeeWon.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(16)
            $0.bottom.equalTo(retrenchCO2Value)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        seeMyOrderHistoryButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(retrenchView)
            $0.height.equalTo(47)
            $0.top.equalTo(retrenchView).offset(147)
        }
        
        seeMyReviewsButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(retrenchView)
            $0.height.equalTo(47)
            $0.top.equalTo(seeMyOrderHistoryButton).offset(62)
        }
        
        serviceCenterButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(retrenchView)
            $0.height.equalTo(47)
            $0.top.equalTo(seeMyReviewsButton).offset(62)
        }
        
        changeDefaultAddressButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(retrenchView)
            $0.height.equalTo(47)
            $0.top.equalTo(serviceCenterButton).offset(62)
        }
        
    }
    
    func addAction() {
        settingBtn.addTarget(self, action: #selector(setProfile), for: .touchUpInside)
        mainProfileImgCameraBtn.addTarget(self, action: #selector(setProfileImg), for: .touchUpInside)
        userNickNameModifyBtn.addTarget(self, action: #selector(modifyNickName), for: .touchUpInside)
        
        //로그아웃 후 초기화면으로 전환
        logOutLabel.rx.tapGesture()
            .when(.recognized)
            .bind{ [weak self] _ in
                guard let self = self else { return }
                let destination = PopupViewController()
                destination.confirmListener = {
                    UserDefaultsManager.DIVIDE_TOKEN = nil
                    UserDefaultsManager.displayName = nil
                    UserDefaultsManager.userPosition = nil
                    UserDefaultsManager.appleUserInfo = nil
                    UserDefaultsManager.userId = nil
                    UserDefaultsManager.FirebaseEmail = nil
                    UserDefaultsManager.FirebasePassword = nil
                    UserDefaultsManager.coordinates = nil
                    
                    guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    guard let firstWindow = window.windows.first else { return }
                    
                    self.navigationController?.popToRootViewController(animated: false)
                    
                    firstWindow.rootViewController = UINavigationController(rootViewController: LoginViewController())
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print(error.localizedDescription)
                    }
                    if AuthApi.hasToken() {
                        print("========================")
                        print("     카카오 로그인 상태")
                        print("========================")
                        UserApi.shared.logout { error in
                            if let error = error {
                                print(error)
                            } else {
                                print("========================")
                                print("카카오 로그아웃 성공")
                                print("========================")
                            }
                        }
                    }
                    
                }
                destination.dismissListener = nil
                destination.setPopupMessage(message: "로그아웃 하시겠습니까?", popupType: .SELECT)
                destination.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(destination, animated: false)

            }.disposed(by: disposeBag)
        
        withdrawalButton.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _  in
                guard let self = self else { return }
                let destination = PopupViewController()
                destination.confirmListener = {
//                    회원 탈퇴
//                    UserDefaultsManager.DIVIDE_TOKEN = nil
//                    UserDefaultsManager.displayName = nil
//                    UserDefaultsManager.userPosition = nil
//                    UserDefaultsManager.appleUserInfo = nil
//                    UserDefaultsManager.userId = nil
//                    UserDefaultsManager.FirebaseEmail = nil
//                    UserDefaultsManager.FirebasePassword = nil
//                    UserDefaultsManager.coordinates = nil
                    
                    guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    guard let firstWindow = window.windows.first else { return }
                    
                    self.navigationController?.popToRootViewController(animated: false)
                    
                    firstWindow.rootViewController = UINavigationController(rootViewController: LoginViewController())
                }
                destination.dismissListener = nil
                destination.setPopupMessage(message: "회원 탈퇴를 하시겠습니까?", popupType: .SELECT)
                destination.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(destination, animated: false)

            }.disposed(by: disposeBag)
        
        
        seeMyOrderHistoryButton.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }
            let destination = MyOrderHistoryViewController()
            self.navigationController?.pushViewController(destination, animated: true)
        }), for: .touchUpInside)
        
        seeMyReviewsButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            let destination = MyReviewViewController()
            self.navigationController?.pushViewController(destination, animated: true)
       
        }), for: .touchUpInside)
        
        serviceCenterButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            if MFMailComposeViewController.canSendMail() {
                    let composeViewController = MFMailComposeViewController()
                    composeViewController.mailComposeDelegate = self
                    
                    let bodyString = """
                                     이곳에 내용을 작성해주세요.
                                     
                                     <예시>
                                     문의 사항 : 팔로우 조회가 안돼요.
                                     접근 방식 : 프로필 설정 버튼을 여러번 누른다음 팔로우 조회를 하려고 했더니 팔로우 조회 화면으로 넘어가지 않아요 ...
                                     
                                     -------------------
                                     
                                     기기 종류 ex) iPhone 13   :
                                     Device OS               : \(UIDevice.current.systemVersion)
                                     App Version             : \(self.getCurrentVersion())
                                     
                                     -------------------
                                     """
                    
                    composeViewController.setToRecipients(["wcbe9745@naver.com"])
                    composeViewController.setSubject("[디바이드] 문의 사항")
                    composeViewController.setMessageBody(bodyString, isHTML: false)
                    
                    self.present(composeViewController, animated: true, completion: nil)
                } else {
                    print("메일 보내기 실패")
                    let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
                    let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                        // 앱스토어로 이동하기(Mail)
                        if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }
                    let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                    
                    sendMailErrorAlert.addAction(goAppStoreAction)
                    sendMailErrorAlert.addAction(cancleAction)
                    self.present(sendMailErrorAlert, animated: true, completion: nil)
                }
        }), for: .touchUpInside)
        
        changeDefaultAddressButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            let destination = ChangeDefaultAddressViewController()
            self.navigationController?.pushViewController(destination, animated: true)
        }), for: .touchUpInside)
        
        followingCount.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                let destination = FollowViewController()
                destination.type = .FOLLOWING
                self.navigationController?.pushViewController(destination, animated: true)
            }.disposed(by: disposeBag)
        
        followerCount.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                let destination = FollowViewController()
                destination.type = .FOLLOWER
                self.navigationController?.pushViewController(destination, animated: true)
            }.disposed(by: disposeBag)
    }

    // 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    @objc func setProfile() {
        // 수정 후 제출
        if settingBtn.isSelected == true {
            settingBtn.isSelected = false
                        
            mainProfileImgGrayTint.alpha = 0
            mainProfileImgCameraBtn.alpha = 0
            userNickNameModifyBtn.alpha = 0
            
            allComponents.forEach {
                $0.alpha = 1
            }
            
            userNickName.borderWidth = 0
            userNickName.isEnabled = false
            userNickName.backgroundColor = .clear
            userNickName.layer.shadowOpacity = 0
            userNickName.snp.updateConstraints {
                $0.centerY.equalTo(mainProfile)
                $0.height.equalTo(23)
            }
            userNickName.resignFirstResponder()
            
            modifyMyProfileIfChanged()
            
        } else {
            // 수정 화면 진입
            settingBtn.isSelected = true
            
            mainProfileImgGrayTint.alpha = 1
            mainProfileImgCameraBtn.alpha = 1
            userNickNameModifyBtn.alpha = 1
            
            allComponents.forEach {
                $0.alpha = 0.5
            }
            userNickName.isEnabled = true
            userNickName.backgroundColor = .white
            userNickName.layer.addShadow(location: .all)
            userNickName.snp.updateConstraints {
                $0.centerY.equalTo(mainProfile).offset(79.5)
                $0.height.equalTo(30)
            }
        }
        
    }
    @objc func setProfileImg() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    @objc func modifyNickName() {
        userNickName.becomeFirstResponder()
    }
    
    private func bindProfile() {
        mainProfileImageIndicator.startAnimating()
        
        viewModel?.requestMyProfile()
            .asObservable()
            .bind(onNext: { [weak self] profileModel in
                guard let self = self else { return }
                self.userNickName.text = profileModel.nickname
                self.mainProfileImageIndicator.startAnimating()
                self.mainProfileImageView.load(url: profileModel.profileImgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, completion: {
                    DispatchQueue.main.async {
                        self.mainProfileImageIndicator.stopAnimating()
                    }
                })
                self.mainProfileTag.text = profileModel.badge.name
                self.userNickName.text = profileModel.nickname
                self.followingCount.text = String(profileModel.followingCount)
                self.followerCount.text = String(profileModel.followerCount)
                self.retrenchDeliveryFeeValue.text = String(profileModel.savedPrice)
                UserDefaultsManager.userPosition = profileModel.location
                self.beforeProfile = ModifyProfileModel(nickname: profileModel.nickname,
                                                        badgeName: profileModel.badge.name,
                                                        latitude: profileModel.location.latitude,
                                                        longitude: profileModel.location.longitude)
            }).disposed(by: disposeBag)
    }
    private func modifyMyProfileIfChanged() {
        var newProfile = ModifyProfileModel()
        var newImage : Data?
        var profileChanged = false
        if self.beforeProfile?.nickname != self.userNickName.text {
            newProfile.nickname = self.userNickName.text!
            profileChanged = true
        }
        if self.beforeProfile?.badgeName != self.mainProfileTag.text {
            newProfile.badgeName = self.mainProfileTag.text!
            profileChanged = true
        }
        if self.beforeProfile?.latitude != UserDefaultsManager.userPosition?.latitude {
            newProfile.latitude = UserDefaultsManager.userPosition!.latitude
            profileChanged = true
        }
        if self.beforeProfile?.longitude != UserDefaultsManager.userPosition?.longitude {
            newProfile.longitude = UserDefaultsManager.userPosition!.longitude
            profileChanged = true
        }
        if self.isImageChanged {
            newImage = self.mainProfileImageView.image?.jpegData(compressionQuality: 0.5)
            profileChanged = true
        }
        
        if profileChanged{
            viewModel?.modifyMyProfile(profile: newProfile, img: newImage, completion: {
                print("프로필 수정 됐나요?")
            })
            
        }
        
    }
}
extension ProfileViewController: UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil                    // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage                    // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage                    // 원본 이미지가 있을 경우
        }
        
        self.mainProfileImageView.image = newImage      // 받아온 이미지를 update
        self.isImageChanged = true                      // 프로필 수정에 필요
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌

    }
}

extension ProfileViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 8 {
            textField.text = String(text.dropLast(1))
        }
    }
}
