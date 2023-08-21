//
//  DVIDEViewController.swift
//  DIVIDE
//
//  Created by 임우섭 on 2023/08/21.
//

import UIKit
import SnapKit
import Then

class DVIDEViewController: UIViewController {
    private let topTitleView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .viewBackgroundGray
        
        self.view.addSubview(topTitleView)
        
        topTitleView.do {
            $0.backgroundColor = .white
            $0.layer.addBorder([.bottom], color: .borderGray, width: 1)
            $0.layer.addShadow(location: .bottom)
        }
        
        topTitleView.snp.makeConstraints {
            $0.height.equalTo(113)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.snp.top)
        }
    }
    

    

}
