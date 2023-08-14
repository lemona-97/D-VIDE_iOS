//
//  PopupViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/14.
//

import UIKit


import Then
import SnapKit

class PopupViewController: UIViewController {

    //property
    var dismissListener : (() -> ())?
    
    //Outlet
    
    private let popupView = UIView()
    private let popupImageView = UIImageView()
    private let popupMessageLabel = MainLabel(type: .Point2)
    private let closeButton       = UIButton(configuration: .borderless())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        addView()
        setLayout()
        addAction()
    }
    
    private func setAttributes() {
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
        }
        
        
        closeButton.do {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        }
    }
    
    private func addView() {
        self.view.addSubview(popupView)
        popupView.addSubviews([popupImageView, popupMessageLabel, closeButton])
    }
    
    private func setLayout() {
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
    
    private func addAction() {
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false) { [weak self]  in
                self?.dismissListener?()
            }
            
        }), for: .touchUpInside)
    }

    public func setPopupMessage(message: String) {
        self.popupMessageLabel.text = message
    }
}
