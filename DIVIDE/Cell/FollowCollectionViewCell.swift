//
//  FollowCollectionViewCell.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/09.
//
import UIKit
import Then
import SnapKit

final class FollowCollectionViewCell: UICollectionViewCell {
        
    private let view                = UIView()
    private let profileImageView    = UIImageView()
    private let profileIndicator    = UIActivityIndicatorView()
    private let nameLabel           = MainLabel(type: .Basics2)
    
    private let buttonBox           = UIView()
    private let followButton        = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(self.contentView.bounds.size)
        setAttribute()
        addView()
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttribute() {
        contentView.backgroundColor = .white
        profileImageView.do {
            $0.cornerRadius = 25
        }
        
        profileIndicator.do {
            $0.color = .mainOrange1
        }
        
        nameLabel.do {
            $0.textAlignment = .left
            $0.text = "닉네임 불러오는중"
            $0.textColor = .black
        }
        
        followButton.do {
            $0.backgroundColor = .gray2
            $0.setTitleColor(.white, for: .normal)
            $0.setBackgroundColor(.gray4, for: .normal)
            $0.setBackgroundColor(.mainOrange1, for: .selected)
            $0.cornerRadius = 11.5
        }
    }
    private func addView() {
        contentView.addSubviews([profileImageView, profileIndicator, nameLabel, buttonBox])
        buttonBox.addSubview(followButton)
    }
    private func setLayout() {

        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        profileIndicator.snp.makeConstraints {
            $0.width.height.equalTo(profileImageView)
            $0.center.equalTo(profileImageView)
        }
        
        buttonBox.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-21)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(63)
        }
        
        followButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing)
            $0.trailing.equalTo(buttonBox.snp.leading)
            $0.height.equalToSuperview()
        }
        
        
    }
    
    public func setData(type : FollowType, info : FollowInfo) {
        profileIndicator.startAnimating()
        if let imageURL = info.profileImgUrl {
            self.profileImageView.load(url: imageURL) {
                DispatchQueue.main.async {
                    self.profileIndicator.stopAnimating()
                }
            }
        }
        
        self.nameLabel.text = info.nickname
        
        if type == .FOLLOWING {
            followButton.setTitle("팔로잉", for: .normal)
            followButton.setTitle("팔로우", for: .selected)
        } else {
            followButton.setTitle("삭제", for: .normal)
        }
    }
    public func setData(type : FollowType, info : OtherFollowModel) {
        profileIndicator.startAnimating()
        if let imageURL = info.profileImgUrl {
            self.profileImageView.load(url: imageURL) {
                DispatchQueue.main.async {
                    self.profileIndicator.stopAnimating()
                }
            }
        }
        
        self.nameLabel.text = info.nickname
        
        if type == .FOLLOWING {
            followButton.setTitle("팔로잉", for: .normal)
            followButton.setTitle("팔로우", for: .selected)
        } else {
            followButton.setTitle("삭제", for: .normal)
        }
    }
}
