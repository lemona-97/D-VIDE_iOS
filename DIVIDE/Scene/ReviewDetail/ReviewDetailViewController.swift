//
//  ReviewDetailViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/02.
//

import Cosmos
import RxSwift

final class ReviewDetailViewController: DVIDEViewController2, ViewControllerFoundation {

    //Property
    private let contentView = UIView()
    
    //content
    private let userImageView = UIImageView()
    private let userImageViewIndicator = UIActivityIndicatorView()
    
    private let userNickname = MainLabel(type: .Basics1)
    private let userLocation = MainLabel(type: .small1)
    private let cosmosView = CosmosView()
    
    private let foodImageView = UIImageView()
    private let foodImageViewIndicator = UIActivityIndicatorView()
    private let likeButton = UIButton()
    private let likeCountLabel = MainLabel(type: .Basics2)
    
    private let storeHashTag = MainLabel(type: .Point4)
    private let contentTextView = UITextView()
    
    private var viewModel : ReviewDetailBusinessLogic?

    private var disposeBag = DisposeBag()
    private var reviewId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setAttribute()
        addView()
        setLayout()
        
        bindContent()
        addAction()
    }
    internal func setUp() {
        viewModel = ReviewDetailViewModel()
    }
    internal func setAttribute() {
        self.view.backgroundColor = .viewBackgroundGray
        
        navigationLabel.do {
            $0.text = "리뷰"
        }
        
        contentView.do {
            $0.backgroundColor = .white
            $0.roundCorner(corners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner], cornerRadius: 26)
            $0.layer.addShadow(location: .all)
        }
        
        userImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 19
            $0.clipsToBounds = true
        }
        
        userImageViewIndicator.do {
            $0.color = .mainOrange1
        }
        userNickname.do {
            $0.text = "유저 닉네임"
        }
        
        userLocation.do {
            $0.text = "주소 불러오는중"
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
        
        foodImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        foodImageViewIndicator.do {
            $0.color = .mainOrange1
        }
        
        likeButton.do {
            $0.setImage(UIImage(named: "like.png"), for: .selected)
            $0.setImage(UIImage(named: "unlike.png"), for: .normal)
        }
        
        likeCountLabel.do {
            $0.text = "0"
        }
        
        
        storeHashTag.do {
            $0.text = ""
            $0.textColor = .highlight
        }
        
        contentTextView.do {
            $0.text = ""
            $0.font = UIFont.NotoSansKR(.regular, size: 12)
            $0.isEditable = false
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = .clear
            $0.textColor = .black
        }
        
    }
    internal func addView() {
        self.view.addSubview(contentView)
        contentView.addSubviews([userImageView,
                                 userImageViewIndicator,
                                 userNickname,
                                 userLocation,
                                 cosmosView,
                                 foodImageView,
                                 foodImageViewIndicator,
                                 likeButton,
                                 likeCountLabel,
                                 storeHashTag,
                                 contentTextView,])
        
    }
    internal func setLayout() {
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-50)
        }
        
        userImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(38)
        }
        
        userImageViewIndicator.snp.makeConstraints {
            $0.width.height.equalTo(userImageView)
            $0.center.equalTo(userImageView)
        }
        userNickname.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(10)
            $0.top.equalTo(userImageView).offset(7)
        }
        userLocation.snp.makeConstraints {
            $0.centerY.equalTo(userNickname)
            $0.leading.equalTo(userNickname.snp.trailing).offset(25)
        }
        cosmosView.snp.makeConstraints {
            $0.leading.equalTo(userNickname)
            $0.top.equalTo(userNickname.snp.bottom).offset(5)
            $0.height.equalTo(12)
        }
        foodImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView).offset(21)
            $0.trailing.equalTo(contentView).offset(-21)
            $0.top.equalTo(userImageView.snp.bottom).offset(13)
            $0.height.equalTo(250)
        }
        foodImageViewIndicator.snp.makeConstraints {
            $0.center.equalTo(foodImageView)
            $0.width.height.equalTo(50)
        }
        likeButton.snp.makeConstraints {
            $0.leading.equalTo(foodImageView)
            $0.top.equalTo(foodImageView.snp.bottom).offset(20)
            $0.height.equalTo(15)
            $0.width.equalTo(17)
        }
        likeCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likeButton.snp.trailing).offset(5)
            $0.bottom.equalTo(likeButton)
        }
        storeHashTag.snp.makeConstraints {
            $0.leading.equalTo(likeButton)
            $0.top.equalTo(likeButton.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        contentTextView.snp.makeConstraints {
            $0.leading.equalTo(storeHashTag)
            $0.trailing.equalToSuperview().offset(-21)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(storeHashTag.snp.bottom).offset(9)
        }
    }
    
    private func bindContent() {
        guard let reviewId = self.reviewId else { return }
        self.userImageViewIndicator.startAnimating()
        self.foodImageViewIndicator.startAnimating()
        
        viewModel?.requestReviewDetail(reviewId: reviewId)
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] reviewDetailData in
                guard let self = self else { return }
                if let profileImgUrl = reviewDetailData.data.user.profileImgUrl {
                    self.userImageView.load(url: profileImgUrl) {
                        self.stopIndicator(indicator: self.userImageViewIndicator)
                    }
                } else {
                    self.stopIndicator(indicator: self.userImageViewIndicator)
                }
                
                self.userNickname.text = reviewDetailData.data.user.nickname
                GeocodingManager.reverseGeocoding(lat: reviewDetailData.data.reviewDetail.latitude, lng: reviewDetailData.data.reviewDetail.longitude) { location in
                    DispatchQueue.main.async {
                        self.userLocation.text = location
                    }
                }
                self.cosmosView.rating      = reviewDetailData.data.reviewDetail.starRating
                self.foodImageView.load(url: reviewDetailData.data.reviewDetail.reviewImgUrl[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                    self.stopIndicator(indicator: self.foodImageViewIndicator)
                }
                self.likeCountLabel.text    = String(reviewDetailData.data.reviewDetail.likeCount)
                self.storeHashTag.text      = "# " + reviewDetailData.data.reviewDetail.storeName.removingPercentEncoding!
                self.contentTextView.text   = reviewDetailData.data.reviewDetail.content
                if reviewDetailData.data.reviewDetail.isLiked {
                    self.likeButton.isSelected = true
                }
            }).disposed(by: self.disposeBag)
    }
    
    internal func addAction() {
        likeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            
            if self.likeButton.isSelected {
                if let reviewId = self.reviewId {
                    viewModel?.requestReviewUnLike(reviewId: reviewId, completion: { result in
                        switch result {
                        case .success(let response):
                            print("취소된 리뷰 ID : \(response.reviewId)")
                            self.likeCountLabel.text = String(Int(self.likeCountLabel.text ?? "0")! - 1)
                            self.likeButton.isSelected = false
                        case .failure(let err):
                            print(err)
                        }
                    })
                }
                
            } else {
                if let reviewId = self.reviewId {
                    viewModel?.requestReviewLike(reviewId: reviewId, completion: { result in
                        switch result {
                        case .success(let response):
                            print("리뷰 좋아요 ID : \(response.reviewLikeId)")
                            self.likeCountLabel.text = String(Int(self.likeCountLabel.text ?? "0")! + 1)
                            self.likeButton.isSelected = true
                        case .failure(let err):
                            print(err)
                        }
                    })
                }
            }
        }), for: .touchUpInside)
    }
    
    func setReviewId(reviewId : Int) {
        self.reviewId = reviewId
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
}
