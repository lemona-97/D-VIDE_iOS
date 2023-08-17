//
//  ReviewTableViewCell.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/12/22.
//

import UIKit
import RxGesture
import RxSwift

import SnapKit
import Then
import Cosmos

final class ReviewTableViewCell: UITableViewCell {
    
    private let detailContentsView = UIView()
    private let userImageView = UIImageView()
    private let userImageViewIndicator = UIActivityIndicatorView()
    private let userID = MainLabel(type: .Basics3)
    private let userLocation = MainLabel(type: .small1)
    let reviewLikeCount = MainLabel(type: .small1)
    let likeButton = UIButton()
    private let foodImageView = UIImageView()
    private let foodImageViewIndicator = UIActivityIndicatorView()
    private let storeNameTag = MainLabel(type: .Point3)
    private let contentTextView = UITextView()
    private let cosmosView = CosmosView()
    
    var likeLisenter : (() -> ())?
    var detailLisenter : (() -> ())?
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: .value1, reuseIdentifier: "ReviewTableViewCell")
        setAttribute()
        addView()
        setLayout()
        addAction()
    }
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }
    
//    override func prepareForReuse() {
//        <#code#>
//    }
    
    
    private func setAttribute() {
        self.backgroundColor = .viewBackgroundGray
        contentView.backgroundColor = .viewBackgroundGray
        
        detailContentsView.do {
            $0.roundCorners(cornerRadius: 26, maskedCorners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
            $0.backgroundColor = .white
            $0.layer.addShadow(location: .all)
        }
        
        userImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.cornerRadius = 14
        }
        
        userImageViewIndicator.do {
            $0.color = .mainOrange1
        }
        
        userID.do {
            $0.text = "ID 불러오는중"
        }
        
        userLocation.do {
            $0.text = "주소 불러오는중"
        }
        
        reviewLikeCount.do {
            $0.text = "12345"
        }
        
        likeButton.do {
            $0.setImage(UIImage(named: "like.png"), for: .selected)
            $0.setImage(UIImage(named: "unlike.png"), for: .normal)
        }
        
        foodImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.cornerRadius = 13
        }
        
        foodImageViewIndicator.do {
            $0.color = .mainOrange1
        }
        
        storeNameTag.do {
            $0.text = "#금돼지 맛집"
            $0.textColor = .highlight
        }
        contentTextView.do {
            $0.text = "금돼지식당 드실분~제가 LA에 있을때는 말이죠 정말 제가 꿈에무대 메이저리그로 진출하고 식당마다 싸인해달라 기자들은 항상 붙어다니며 ..."
            $0.font = UIFont.NotoSansKR(.regular, size: 12)
            $0.isEditable = false
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = .clear
            $0.textColor = .black
        }
        cosmosView.do {
            $0.settings.fillMode        = .precise
            $0.settings.updateOnTouch   = false
            $0.settings.starSize        = 11
            $0.settings.filledImage     = UIImage(named: "filledStar")
            $0.settings.emptyImage      = UIImage(named: "unfilledStar")
            $0.settings.starMargin      = 5
            $0.settings.filledColor     = .mainOrange1
            $0.settings.emptyColor      = .viewBackgroundGray
        }
    }
    
    private func addView() {
        contentView.addSubview(detailContentsView)
        detailContentsView.addSubviews([userImageView, userImageViewIndicator, userID, userLocation, reviewLikeCount, likeButton])
        detailContentsView.addSubviews([foodImageView, foodImageViewIndicator, storeNameTag, contentTextView, cosmosView])
    }
    
    private func setLayout() {
        detailContentsView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(146)
        }
        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(28)
            $0.width.equalTo(28)
        }
        userImageViewIndicator.snp.makeConstraints {
            $0.center.equalTo(userImageView)
            $0.width.height.equalTo(userImageView.snp.width)
        }
        userID.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(10)
            $0.top.equalToSuperview().offset(14)
            $0.height.equalTo(21)
            $0.width.equalTo(100)
        }
        userLocation.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(155)
            $0.top.equalToSuperview().offset(14)
            $0.height.equalTo(21)
            $0.width.equalTo(100)
        }
        reviewLikeCount.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-35)
            $0.top.equalToSuperview().offset(14)
            $0.height.equalTo(21)
            $0.width.equalTo(35)
        }
        likeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(25)
            $0.width.equalTo(28)
        }
        
        foodImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(19)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(86)
            $0.width.equalTo(87)
        }
        
        foodImageViewIndicator.snp.makeConstraints {
            $0.center.equalTo(foodImageView)
            $0.width.height.equalTo(foodImageView.snp.height)
        }
        storeNameTag.snp.makeConstraints {
            $0.leading.equalTo(foodImageView.snp.trailing).offset(20)
            $0.top.equalTo(foodImageView).offset(1)
            $0.height.equalTo(21)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(storeNameTag.snp.bottom)
            $0.leading.equalTo(storeNameTag).offset(-5)
            $0.height.equalTo(43)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        cosmosView.snp.makeConstraints {
            $0.leading.equalTo(contentTextView)
            $0.height.equalTo(12)
            $0.top.equalTo(contentTextView.snp.bottom).offset(5)
        }
    }
    private func showIndicator(indicator : UIActivityIndicatorView) {
        if indicator == self.foodImageViewIndicator {
            self.foodImageViewIndicator.startAnimating()
        } else {
            self.userImageViewIndicator.startAnimating()
        }
    }
    private func stopIndicator(indicator : UIActivityIndicatorView) {
        if indicator == self.foodImageViewIndicator {
            self.foodImageViewIndicator.stopAnimating()
        } else {
            self.userImageViewIndicator.stopAnimating()
        }
    }
    
    private func addAction() {
        likeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            if let likeLisenter = likeLisenter {
                likeLisenter()
            }
            
            print("?")
        }), for: .touchUpInside)
        
        detailContentsView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                if let detailLisenter = detailLisenter {
                    detailLisenter()
                }
                print("??")
            }.disposed(by: disposeBag)
        
        
    }
    
    func setData(reviewData : ReviewData) {
        showIndicator(indicator: self.foodImageViewIndicator)
        self.userImageView.load(url: reviewData.user.profileImgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            self.stopIndicator(indicator: self.userImageViewIndicator)
        }
        
        self.userID.text = reviewData.user.nickname
        self.reviewLikeCount.text = String(Int(reviewData.review.likeCount))
        showIndicator(indicator: self.foodImageViewIndicator)
        self.foodImageView.load(url: reviewData.review.reviewImgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            self.stopIndicator(indicator: self.foodImageViewIndicator)
        }
        self.storeNameTag.text = "# " + reviewData.review.storeName.removingPercentEncoding!
        self.contentTextView.text = reviewData.review.content
        self.cosmosView.rating = reviewData.review.starRating
        if reviewData.review.isLiked {
            self.likeButton.isSelected = true
        }
    }
    func setData(review : Review, profileImage : UIImage, nickname : String) {
        showIndicator(indicator: self.foodImageViewIndicator)
        self.userImageView.image = profileImage
        self.stopIndicator(indicator: self.userImageViewIndicator)
        
        
        self.userID.text = nickname
        self.reviewLikeCount.text = String(Int(review.likeCount))
        showIndicator(indicator: self.foodImageViewIndicator)
        self.foodImageView.load(url: review.reviewImgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            self.stopIndicator(indicator: self.foodImageViewIndicator)
        }
        self.storeNameTag.text = "# " + review.storeName.removingPercentEncoding!
        self.contentTextView.text = review.content
        self.cosmosView.rating = review.starRating
        if review.isLiked {
            self.likeButton.isSelected = true
        }
    }
    
    func setLocation(location : String) {
        DispatchQueue.main.async {
            self.userLocation.text = location
        }
        
    }
}
