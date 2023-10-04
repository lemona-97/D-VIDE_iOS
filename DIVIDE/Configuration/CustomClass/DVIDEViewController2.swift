//
//  DVIDEViewController2.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/22.
//

import UIKit
import Then
import SnapKit

class DVIDEViewController2: UIViewController {
    let navigationView                  = UIView()
    let navigationLabel                 = MainLabel(type: .hopang)
    let backButton                      = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()

        // setAttribute
        self.view.backgroundColor = .white
        
        navigationView.do {
            $0.backgroundColor = .white
            $0.layer.addBorder([.bottom], color: .borderGray, width: 1)
            $0.layer.addShadow(location: .bottom)
        }
        
        backButton.do {
            $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            $0.tintColor = .gray
        }
        
        // addView
        view.addSubview(navigationView)
        navigationView.addSubview(navigationLabel)
        navigationView.addSubview(backButton)

        //satLayout
        navigationView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        navigationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(navigationView.snp.bottom).offset(-20)
        }
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalTo(navigationLabel)
            $0.width.height.equalTo(30)
        }
        
        //addAction
        backButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            print(self.navigationController?.viewControllers)
            self.navigationController?.popViewController(animated: true)
            
        }), for: .touchUpInside)
    }

}
