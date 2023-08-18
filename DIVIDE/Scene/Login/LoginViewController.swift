//
//  LoginViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/04.
//

import UIKit
import Then
import SnapKit
import RxGesture
import RxSwift

import FirebaseAuth
import KakaoSDKUser
import KakaoSDKAuth
import AuthenticationServices
import CoreLocation

final class LoginViewController: UIViewController {
    
    private let catchphraseLabel        = MainLabel(type: .Point4)
    private let halfBubbleImageView     = UIImageView()
    private let mainImageView           = UIImageView()
    private let bottomImageView         = UIImageView()
    
    private let emailTextField          = UITextField()
    private let passwordTextField       = UITextField()
    
    private let kakaoLoginImage         = UIImageView()
    private let appleLoginImage         = UIImageView()
    private let loginButton             = MainButton(type: .mainAction)
    private let signupButton            = UIButton()
    
    private var locationManager         = CLLocationManager()
    private var viewModel              : LoginBusinessLogic?
    private var disposeBag              = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setAttribute()
        addView()
        setLayout()
        addAction()
    }
    
    private func setUp() {
        viewModel = LoginViewModel()
        
    }
    private func getUserPosition(completion : @escaping (UserPosition) -> Void) {
        guard let lat = locationManager.location?.coordinate.latitude, let lng = locationManager.location?.coordinate.longitude else { return print("유저 위치 정보 못가져왔음") }
        UserDefaultsManager.userPosition = UserPosition(longitude: lng, latitude: lat)
        completion(UserPosition(longitude: lng, latitude: lat))
    }
    private func setAttribute() {
        self.view.backgroundColor = .white
        
        catchphraseLabel.do {
            $0.text = "나와 디바이더가 되어 \n나누러 가볼까?"
            $0.numberOfLines = 2
        }
        
        halfBubbleImageView.do {
            $0.image = UIImage(named: "loginMainHalfBubble")
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = false
        }
        
        mainImageView.do {
            $0.image = UIImage(named: "loginMainImage")
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = false
        }
        
        bottomImageView.do {
            $0.image = UIImage(named: "loginBottomImage")
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = false
        }
        
        emailTextField.do {
            $0.addLeftImage(image: UIImage(systemName: "person")!)
            $0.textColor = .black
            $0.roundCorner(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 5)
            $0.font = .AppleSDGothicNeo(.bold, size: 12)
            $0.attributedPlaceholder = NSAttributedString(string: "이메일", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray2])
            $0.textContentType = .emailAddress
            $0.tintColor = .mainOrange1
            $0.delegate = self
            $0.borderColor = .gray3
            $0.borderWidth = 1        }
        
        passwordTextField.do {
            $0.addLeftImage(image: UIImage(systemName: "lock")!)
            $0.isSecureTextEntry = true
            $0.textColor = .black
            $0.roundCorner(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 5)
            $0.cornerRadius = 5
            $0.font = .AppleSDGothicNeo(.bold, size: 12)
            $0.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray2])
            $0.textContentType = .password
            $0.tintColor = .mainOrange1
            $0.delegate = self
            $0.borderColor = .gray3
            $0.borderWidth = 1
        }
        
        kakaoLoginImage.do {
            $0.image = UIImage(named: "kakaoLogin")
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = false
            $0.cornerRadius = 22.5
            $0.backgroundColor = .kakaoContainer
        }
        
        appleLoginImage.do {
            $0.roundCorners(cornerRadius: 22.5, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner ,.layerMinXMinYCorner])
            $0.image = UIImage(named: "AppleLogin")
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .black
        }
    
        loginButton.do {
            $0.setTitle("로그인", for: .normal)
            $0.cornerRadius = 22.5
        }
        
        signupButton.do {
            $0.setTitle("회원 가입", for: .normal)
            $0.setTitleColor(.gray2, for: .normal)
            $0.titleLabel?.setUnderline(range: NSRange(location: 0, length: $0.currentTitle?.count ?? 0))
        }
    }
    
    private func addView() {
        self.view.addSubviews([catchphraseLabel, halfBubbleImageView, mainImageView, bottomImageView])
        self.view.addSubviews([emailTextField, passwordTextField, loginButton, kakaoLoginImage, appleLoginImage])
        self.view.addSubview(signupButton)
    }
    private func setLayout() {
        halfBubbleImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(39)
            $0.top.equalToSuperview().offset(120)
            $0.width.equalTo(SIZE.width / 3)
            $0.height.equalTo(50)
        }
        
        catchphraseLabel.snp.makeConstraints {
            $0.leading.equalTo(halfBubbleImageView)
            $0.bottom.equalTo(halfBubbleImageView.snp.top).offset(15)
            $0.height.equalTo(60)
            $0.width.equalTo(200)
        }
        
        mainImageView.snp.makeConstraints {
            $0.leading.equalTo(halfBubbleImageView.snp.centerX)
            $0.top.equalTo(halfBubbleImageView.snp.bottom)
            $0.trailing.equalToSuperview().offset(-31)
            $0.height.equalTo(160)
        }
        
        bottomImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-26)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(83)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(39)
            $0.trailing.equalToSuperview().offset(-39)
            $0.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(emailTextField)
            $0.trailing.equalToSuperview().offset(-39)
            $0.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(39)
            $0.trailing.equalToSuperview().offset(-39)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.height.equalTo(45)
        }
        
        kakaoLoginImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(39)
            $0.trailing.equalToSuperview().offset(-39)
            $0.top.equalTo(loginButton.snp.bottom).offset(10)
            $0.height.equalTo(45)
        }
        
        appleLoginImage.snp.makeConstraints {
            $0.leading.equalTo(kakaoLoginImage)
            $0.trailing.equalTo(kakaoLoginImage)
            $0.top.equalTo(kakaoLoginImage.snp.bottom).offset(10)
            $0.height.equalTo(45)
        }
        
        signupButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(appleLoginImage)
            $0.top.equalTo(appleLoginImage.snp.bottom).offset(30)
            $0.height.equalTo(10)
        }
    }
    
    private func addAction() {
        loginButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            viewModel?.divideSignIn(email: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { result in
                switch result {
                case .success(let response):
                    UserDefaultsManager.DIVIDE_TOKEN = response.token
                    UserDefaultsManager.userId = response.userId
                    self.getUserPosition { [weak self] userPosition in
                        guard let self = self else { return }
                        print("userPosition : \(userPosition)")
                        self.viewModel?.setUserPositon(userPosition: userPosition) {
                            self.navigationController?.popViewController(animated: true)
                            print("=========================================================================")
                            print("                             로그인 VC pop")
                            print("=========================================================================")

                            self.navigationController?.pushViewController(TabBarController(), animated: true)
                            print("=========================================================================")
                            print("                             탭바 pushed !")
                            print("=========================================================================")

                        }
                    }
                case .failure(let err):
                    print(err)
                }
            })
        }), for: .touchUpInside)
        
        kakaoLoginImage.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            
                            // 카카오 토큰 우리 서버에 전송
                            guard let accessToken = oauthToken?.accessToken else { return }
                            
                            KAKAO_ACCESS_TOKEN = accessToken
                            self.viewModel?.kakaoSignUp(accessToken: accessToken) { [weak self] result in
                                guard let self = self else { return }
                                switch result {
                                case .success(let response):
                                    print("=========================================================================")
                                    print("                         카카오 회원가입 or 로그인 성공")
                                    print("=========================================================================")
                                    
                                    print("=========================================================================")
                                    print("                         서버에서 받아온 토큰 : ", response.token)
                                    print("=========================================================================")
                                    
                                    UserDefaultsManager.DIVIDE_TOKEN = response.token
                                    print("=========================================================================")
                                    print("                         카카오로 회원가입된 userID :", response.userId)
                                    print("=========================================================================")
                                    
                                    print("=========================================================================")
                                    print("                         loginWithKakaoTalk() success.")
                                    print("=========================================================================")
                                    UserDefaultsManager.userId = response.userId
                                    
                                    print("=========================================================================")
                                    UserApi.shared.me { user, error in
                                        print("              사용자 이메일",user?.kakaoAccount?.email, "로 firebase 가입")
                                        // 카카오 이메일로 파이어베이스 가입 (채팅에 필요)
                                        Auth.auth().createUser(withEmail: (user?.kakaoAccount?.email)!, password: (user?.kakaoAccount?.email)! + "kakaoLogin")
                                    }
                                    print("=========================================================================")
                                    self.getUserPosition { [weak self] userPosition in
                                        guard let self = self else { return }
                                        print("userPosition : \(userPosition)")
                                        self.viewModel?.setUserPositon(userPosition: userPosition) {
                                            self.navigationController?.popViewController(animated: true)
                                            print("=========================================================================")
                                            print("                             로그인 VC pop")
                                            print("=========================================================================")

                                            self.navigationController?.pushViewController(TabBarController(), animated: true)
                                            print("=========================================================================")
                                            print("                             탭바 pushed !")
                                            print("=========================================================================")

                                        }
                                    }
                                    
                                case .failure(let err):
                                    print(err)
                                }
                            }
                           
                        }
                    }
                }
            }.disposed(by: disposeBag)
        
        appleLoginImage.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.appleLoginHandler()
            }.disposed(by: disposeBag)
          
        

        
        signupButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            let destination = SignUpViewController()
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.pushViewController(destination, animated: true)
        }), for: .touchUpInside)
    }
    
    /// 애플 로그인 호출
    private func appleLoginHandler() {
        if let appleUserInfo = UserDefaultsManager.appleUserInfo {
            
            viewModel?.divideSignIn(email: appleUserInfo.email!, password: appleUserInfo.email! + "appleLogin", completion: { result in
                switch result {
                case .success(let response):
                    UserDefaultsManager.DIVIDE_TOKEN = response.token
                    UserDefaultsManager.userId = response.userId
                case .failure(let err):
                    print(err)
                }
            })
            
        } else {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            // 추후 : DB에 저장 ? 필요함^^
            request.requestedScopes = [.fullName, .email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
            controller.performRequests()
        }
    }
}

extension LoginViewController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = credential.user
            print("애플 유저 이름")
            print("👨‍🍳 \(user)")
            
            //로그인 정보 있으면 넘어가~
            if let info = UserDefaultsManager.appleUserInfo {
                return
            }
            var info = AppleLoginInfo(user: user)

            if let email = credential.email {
                print("애플 유저 이메일")
                print("✉️ \(email)")
                
                // 애플 privacy 이메일로 파이어베이스 가입 (채팅에 필요)
                Auth.auth().createUser(withEmail: email, password: email + "appleLogin")
                
                // 자체 로그인 서비스로 가입 진행
                let signUpImage = UIImage(named: "loginMainImage")!
                let signUpImageData = signUpImage.jpegData(compressionQuality: 0.5)!
                viewModel?.divideSignUp(signUpInfo: SignUpModel(email: email, password: email+"appleLogin", nickname: email), img: signUpImageData, completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let response):
                        // userId 저장 해주고
                        UserDefaultsManager.userId = response.userId
                        
                        // 해당 정보로 로그인 바로 해줌 ㅎㅎ
                        self.viewModel?.divideSignIn(email: email, password: email+"appleLogin", completion: { result in
                            switch result {
                            case .success(let response):
                                UserDefaultsManager.DIVIDE_TOKEN = response.token
                                UserDefaultsManager.userId = response.userId
                                self.getUserPosition { userPosition in
                                    print("userPosition : \(userPosition)")
                                    self.viewModel?.setUserPositon(userPosition: userPosition) {
                                        self.navigationController?.popViewController(animated: true)
                                        print("=========================================================================")
                                        print("                             로그인 VC pop")
                                        print("=========================================================================")

                                        self.navigationController?.pushViewController(TabBarController(), animated: true)
                                        print("=========================================================================")
                                        print("                             탭바 pushed !")
                                        print("=========================================================================")

                                    }
                                }
                            case .failure(let err):
                                print(err)
                            }
                        })
                    case .failure(let err):
                        print(err)
                    }
                })
                
                info.email = email
                UserDefaultsManager.appleUserInfo = info
            }
            
   
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 에러 발생")
        print("error \(error)")
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                textField.resignFirstResponder()
            }.disposed(by: disposeBag)
        textField.borderColor = .mainOrange1
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderColor = .gray3
        textField.deleteRightButton()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == "" {
            textField.deleteRightButton()
        } else {
            textField.addRightClearButton()
        }
    }
}
