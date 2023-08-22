//
//  PopupViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/14.
//

import UIKit
import Then
import SnapKit

final class PopupViewController: UIViewController {

    //property
    var dismissListener : (() -> ())?
    var confirmListener : (() -> ())?
    private var popupType : PopupType?
    //Outlet
    
    private let popupView = UIView()
    private let popupImageView = UIImageView()
    private let popupMessageLabel = MainLabel(type: .Point2)
    private let closeButton       = UIButton(configuration: .borderless())
    
    private let cancelButton      = UIButton()
    private let confirmButton     = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setByType()
    }
    
    private func setByType() {
        if self.popupType == .ALERT {
            setAlertAttributes()
            addAlertView()
            setAlertLayout()
            addAlertAction()
        }
        
        if self.popupType == .SELECT {
            setSelectAttributes()
            addSelectView()
            setSelectLayout()
            addSelectAction()
        }
    }
    private func setAlertAttributes() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        popupView.do {
            $0.backgroundColor = .white
            $0.cornerRadius = 26
        }
        
        popupImageView.do {
            $0.image = UIImage(named: "popupImage")
            $0.contentMode = .scaleAspectFit
        }
        
        popupMessageLabel.do {
            $0.textColor = .gray3
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        
        closeButton.do {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = .black
        }
    }
    
    private func addAlertView() {
        self.view.addSubview(popupView)
        popupView.addSubviews([popupImageView, popupMessageLabel, closeButton])
    }
    
    private func setAlertLayout() {
        popupView.snp.makeConstraints {
            $0.height.equalTo(178)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        popupImageView.snp.makeConstraints {
            $0.centerX.equalTo(popupView)
            $0.top.equalToSuperview().offset(30)
            $0.height.width.equalTo(83)
        }
        
        popupMessageLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(popupImageView.snp.bottom).offset(17)
            $0.bottom.equalToSuperview().offset(-32)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.height.equalTo(40)
        }
    }
    
    private func addAlertAction() {
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false) { [weak self]  in
                if let dismissListener = self?.dismissListener {
                    self?.dismissListener?()
                }
            }
            
        }), for: .touchUpInside)
    }

    
    private func setSelectAttributes() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        popupView.do {
            $0.backgroundColor = .white
            $0.cornerRadius = 4
        }
        
        popupImageView.do {
            $0.image = UIImage(named: "popupImage")
            $0.contentMode = .scaleAspectFit
        }
        
        popupMessageLabel.do {
            $0.textColor = .gray3
            $0.textAlignment = .center
        }
        
        closeButton.do {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = .black
        }
        
        cancelButton.do {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .gray1
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .mainOrange2
        }
    }
    
    private func addSelectView() {
        self.view.addSubview(popupView)
        popupView.addSubviews([popupImageView, popupMessageLabel, closeButton, cancelButton, confirmButton])
    }
    
    private func setSelectLayout() {
        popupView.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        popupImageView.snp.makeConstraints {
            $0.centerX.equalTo(popupView)
            $0.top.equalToSuperview().offset(30)
            $0.height.width.equalTo(83)
        }
        
        popupMessageLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(popupImageView.snp.bottom).offset(17)
            $0.height.equalTo(20)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalTo(popupView.snp.centerX).offset(-5)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
        }
        
        confirmButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-5)
            $0.leading.equalTo(popupView.snp.centerX).offset(5)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
        }
    }
    
    private func addSelectAction() {
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false)
        }), for: .touchUpInside)
        
        cancelButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false)
        }), for: .touchUpInside)
        
        confirmButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false) { [weak self] in
                self?.confirmListener?()
            }
        }), for: .touchUpInside)
    }
    
    public func setPopupMessage(message: String, popupType : PopupType) {
        self.popupMessageLabel.text = message
        self.popupType = popupType
    }
}
