//
//  SignUpViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/16.
//

import UIKit
import PhotosUI
import RxSwift
import RxGesture

import Then
import SnapKit


class SignUpViewController: UIViewController {

    //Outlets
    private let backButton                  = UIButton()
    private let titleLabel                  = MainLabel(type: .title)
    
    private let emailLabel                  = MainLabel(type: .Point2)
    private let emailTextField              = UITextField()
    private let emailWarningLabel           = MainLabel(type: .warning)
    
    private let passwordLabel               = MainLabel(type: .Point2)
    private let passwordTextField           = UITextField()
    private let passwordWarningLabel        = MainLabel(type: .warning)
    
    private let passwordLabel2              = MainLabel(type: .Point2)
    private let passwordTextField2          = UITextField()
    private let passwordWarningLabel2       = MainLabel(type: .warning)
    
    private let profileImageLabel           = MainLabel(type: .Point4)
    private let profileImageView            = UIImageView()
    private let nicknameLabel               = MainLabel(type: .Point4)
    private let nicknameTextField           = UITextField()
    private let signUpButton                = MainButton(type: .mainAction)
    
    private var photoConfiguration          = PHPickerConfiguration()
    
    
    private var viewModel                   : SignUpBusinessLogic?
    private var disposeBag                  = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setAttribute()
        addView()
        setLayout()
        addAction()
    }
    private func setUp() {
        viewModel = SignUpViewModel()
    }
    
    private func setAttribute() {
        self.view.backgroundColor = .white
        
        backButton.do {
            $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            $0.tintColor = .black
        }
        
        titleLabel.do {
            $0.text = "디바이더 되기"
            $0.textAlignment = .center
        }
        emailLabel.do {
            $0.text = "이메일"
        }
        emailTextField.do {
            $0.textColor = .black
            $0.setPaddingFor(left: 10)
            $0.font = .AppleSDGothicNeo(.bold, size: 12)
            $0.attributedPlaceholder = NSAttributedString(string: "이메일을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray2])
            $0.textContentType = .emailAddress
            $0.backgroundColor = .viewBackgroundGray
            $0.tintColor = .mainOrange1
            $0.borderColor = .gray3
            $0.borderWidth = 1
            $0.borderStyle = .line
            $0.delegate = self
        }
        
        emailWarningLabel.do {
            $0.text = "* 올바른 이메일 형식이 아닙니다."
            $0.isHidden = true
        }
        
        passwordLabel.do {
            $0.text = "비밀번호 입력"
        }
        
        passwordTextField.do {
            $0.isSecureTextEntry = true
            $0.textColor = .black
            $0.setPaddingFor(left: 10)
            $0.font = .AppleSDGothicNeo(.bold, size: 12)
            $0.attributedPlaceholder = NSAttributedString(string: "영어, 숫자, 특수문자를 포함한 8자리 이상의 비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray2])
            $0.textContentType = .password
            $0.backgroundColor = .viewBackgroundGray
            $0.tintColor = .mainOrange1
            $0.borderColor = .gray3
            $0.borderWidth = 1
            $0.borderStyle = .line
            $0.delegate = self
        }
        
        passwordWarningLabel.do {
            $0.text = "* 8자리이상 영어 + 숫자 + 특수문자"
            $0.isHidden = true
        }
        
        passwordLabel2.do {
            $0.text = "비밀번호 재입력"
        }
        passwordTextField2.do {
            $0.isSecureTextEntry = true
            $0.textColor = .black
            $0.setPaddingFor(left: 10)
            $0.font = .AppleSDGothicNeo(.bold, size: 12)
            $0.attributedPlaceholder = NSAttributedString(string: "비밀번호를 한번 더 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray2])
            $0.textContentType = .password
            $0.backgroundColor = .viewBackgroundGray
            $0.tintColor = .mainOrange1
            $0.borderColor = .gray3
            $0.borderWidth = 1
            $0.borderStyle = .line
            $0.delegate = self
        }
        
        passwordWarningLabel2.do {
            $0.text = "* 비밀번호가 다릅니다"
            $0.isHidden = true
        }
        
        profileImageLabel.do {
            $0.text = "프로필 사진"
        }
        
        profileImageView.do {
            $0.backgroundColor = .gray3
            $0.cornerRadius = 75
            $0.image = UIImage(named: "카메라")
            $0.contentMode = .center
        }

        nicknameLabel.do {
            $0.text = "닉네임 설정"
        }
        
        nicknameTextField.do {
            $0.textColor = .black
            $0.setPaddingFor(left: 10)
            $0.attributedPlaceholder = NSAttributedString(string: "닉네임 입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray2])
            $0.backgroundColor = .viewBackgroundGray
            $0.tintColor = .mainOrange1
            $0.borderColor = .gray3
            $0.borderWidth = 1
            $0.borderStyle = .line
            $0.delegate = self
        }
        
        signUpButton.do {
            $0.setTitle("회원가입 하기", for: .normal)
        }
        
        
    }
    
    private func addView() {
        self.view.addSubviews([backButton, titleLabel, emailLabel, emailTextField, emailWarningLabel, passwordLabel, passwordTextField, passwordWarningLabel, passwordLabel2, passwordTextField2, passwordWarningLabel2, signUpButton, profileImageLabel , profileImageView, nicknameLabel, nicknameTextField])
    }
    
    private func setLayout() {
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(60)
            $0.width.equalTo(30)
            $0.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.equalTo(30)
        }
        
        emailWarningLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(5)
            $0.leading.equalTo(emailTextField)
            $0.trailing.equalTo(emailTextField)
            $0.height.equalTo(20)
        }
        
        emailLabel.snp.makeConstraints {
            $0.bottom.equalTo(emailTextField.snp.top).offset(-5)
            $0.leading.trailing.equalTo(emailTextField)
            $0.height.equalTo(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailWarningLabel.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.equalTo(30)
        }
        
        passwordWarningLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(passwordTextField)
            $0.height.equalTo(20)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.bottom.equalTo(passwordTextField.snp.top).offset(-5)
            $0.leading.trailing.equalTo(passwordTextField)
            $0.height.equalTo(20)
        }
        
        passwordTextField2.snp.makeConstraints {
            $0.top.equalTo(passwordWarningLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalTo(passwordTextField)
            $0.height.equalTo(30)
        }
        
        passwordWarningLabel2.snp.makeConstraints {
            $0.top.equalTo(passwordTextField2.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(passwordTextField2)
            $0.height.equalTo(20)
        }
        
        passwordLabel2.snp.makeConstraints {
            $0.bottom.equalTo(passwordTextField2.snp.top).offset(-5)
            $0.leading.trailing.equalTo(passwordTextField2)
            $0.height.equalTo(20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.height.width.equalTo(150)
            $0.top.equalTo(passwordTextField2.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().offset(-60)
        }
        
        profileImageLabel.snp.makeConstraints {
            $0.leading.equalTo(passwordTextField2).offset(15)
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalTo(profileImageView.snp.leading).offset(-20)
            $0.height.equalTo(20)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageLabel)
            $0.trailing.equalTo(profileImageLabel)
            $0.top.equalTo(profileImageView.snp.bottom).offset(25)
            $0.height.equalTo(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.centerY.equalTo(nicknameLabel)
            $0.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.equalTo(25)
        }
        
        signUpButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-50)
            $0.height.equalTo(50)
        }
    }
    
    private func addAction() {
        profileImageView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.getPhoto()
            }.disposed(by: disposeBag)
        
        signUpButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            let email = self.emailTextField.text!
            let password = self.passwordTextField.text!
            let profileImageData = self.profileImageView.image?.jpegData(compressionQuality: 0.5)
            let nickname = self.nicknameTextField.text!
            
            let signupInfo = SignUpModel(email: email, password: password, nickname: nickname)
            viewModel?.requestSignUp(signUpInfo: signupInfo, imageData: profileImageData!, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    UserDefaultsManager.userId = response.userId
                    self.viewModel?.divideSignIn(email: email, password: password, completion: { result2 in
                        switch result2 {
                        case .success(let loginResponse):
                            UserDefaultsManager.DIVIDE_TOKEN = loginResponse.token
                        case .failure(let loginErr):
                            print(loginErr)
                        }
                    })
                case .failure(let err):
                    print(err)
                }
            })
        }), for: .touchUpInside)
        
        backButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
    }
    private func getPhoto() {
        photoConfiguration.filter = .any(of: [.images])
        photoConfiguration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: photoConfiguration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func showEmailWarning() {
        self.emailWarningLabel.isHidden = false
    }
    
    private func hideEmailWarning() {
        self.emailWarningLabel.isHidden = true
    }
    
    private func showPasswordWarning() {
        self.passwordWarningLabel.isHidden = false
    }
    
    private func hidePasswordWarning() {
        self.passwordWarningLabel.isHidden = true
    }
    
    private func showPasswordWarning2() {
        self.passwordWarningLabel2.isHidden = false
    }
    
    private func hidePasswordWarning2() {
        self.passwordWarningLabel2.isHidden = true
    }
}

extension SignUpViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nicknameTextField {
            self.view.frame.origin.y -= 200
            
        }
        self.view.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                textField.resignFirstResponder()
            }.disposed(by: disposeBag)
        textField.borderColor = .mainOrange1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if !(textField.text?.isValidateEmail())! {
                textField.text = ""
                self.showEmailWarning()
            } else {
                self.hideEmailWarning()
            }
        }
        if textField == passwordTextField {
            if !(textField.text?.isValidatePassword())! {
                textField.text = ""
                self.showPasswordWarning()
            } else {
                self.hidePasswordWarning()
            }
        }
        if textField == nicknameTextField {
            self.view.frame.origin.y += 200
        }
        
        if textField == passwordTextField2 {
            if textField.text != passwordTextField.text {
                self.showPasswordWarning2()
            } else {
                self.hidePasswordWarning2()
            }
        }
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

extension SignUpViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // picker 닫고
        picker.dismiss(animated: true)

        results.forEach { result in
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
                result.itemProvider.loadObject(ofClass: UIImage.self) { (newImage, error) in // 4
                    let newImage = newImage as! UIImage
                    DispatchQueue.main.async {
                        self.profileImageView.image = newImage
                    }
                }
            } else {
                // TODO: Handle empty results or item provider not being able load UIImage
                print("가져온 사진이 없음")
            }
        }
        
    }
}
