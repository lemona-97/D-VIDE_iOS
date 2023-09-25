//
//  OrderTableViewCell.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/07/22.
//

import UIKit
import SnapKit
import Then
import NMapsMap
import SwiftyJSON

// 추후 주문내역 VC에 있을떄 후기 작성 기능 & UI 적용 예정
final class OrderTableViewCell: UITableViewCell {
    private let contentBox = UIView()
    var remainEpochTime : Int?
    
    //MARK: - conponents
    // info
    private let profileImage = UIImageView()
    private let profileIndicator = UIActivityIndicatorView()
    
    private let nickNameLabel = MainLabel(type: .Basics1)
    private let userLocation = MainLabel(type: .small1)
    private let locationIndicator = UIActivityIndicatorView()
    
    // History
    private var orderedTimeTitleLabel = MainLabel(type: .Basics2) {
        didSet {
            orderedTimeTitleLabel.text = "• " + (orderedTimeTitleLabel.text ?? "주문 날짜 불러오는중")
        }
    }
    
    var userId    : Int?
    private var storeName : String?
    private var longitude : Double?
    private var latitude  : Double?
    
    // timeBubble
    private let timeBubble = UIImageView()
    private let remainTimeUnderOneHour = MainLabel(type: .small3)
    
    // content
    private let foodImageView = UIImageView()
    private let foodImageIndicator = UIActivityIndicatorView()
    
    private var postId : Int?
    private let title = MainLabel(type: .Point1)
    private let separateView = UIView()
    
    private let detailBox = UIView()
    private let closingTimeTitle = MainLabel(type: .small2)
    private let AMPMLabel = MainLabel(type: .small3)
    private let closingTimeValue = MainLabel(type: .Big1)
    private let separateMiddleView = UIView()
    private let insufficientChargeTitle = MainLabel(type: .small2)
    private let insufficientChargeValueLabel = MainLabel(type: .Big1)
    private let currency = MainLabel(type: .small3)
    
    private let progressView = UIProgressView(progressViewStyle: .default)
    
    private let orderHistoryBox = UIView()
    
    private let orderedTimeLabel = MainLabel(type: .Basics1)
    private let orderedPriceLabel = MainLabel(type: .Basics1)
    
    private let orderedTimeValueLabel = MainLabel(type: .Basics1)
    private let orderedPriceValueLabel = MainLabel(type: .Basics4)
    private let orderedPriceUnitLabel = MainLabel(type: .Basics1)
    
    private let pastLabel = UILabel()
    
    let dateFormatter = DateFormatter()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "HomeTableViewCell")
        setAttribute()
        addView()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.profileImage.image = nil
        self.foodImageView.image = nil
    }
    
    private func setAttribute() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.contentView.do {
            $0.backgroundColor = .viewBackgroundGray
        }
        
        contentBox.do {
            $0.backgroundColor = .white
            $0.layer.masksToBounds = false
            $0.roundCorner(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], cornerRadius: 26)
            $0.layer.addShadow(location: .all)
        }
        
        profileImage.do{
            $0.image = UIImage(resource: .basicProfileImg)
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.cornerRadius = 14
        }
        
        profileIndicator.do {
            $0.color = .mainOrange1
            $0.hidesWhenStopped = true
            
        }
        
        nickNameLabel.do {
            $0.text = "kksmedd10204"
            $0.textAlignment = .left
        }
        // 지역
        userLocation.do {
            $0.text = "주소 불러오는중"
            $0.textAlignment = .left
        }
        
        locationIndicator.do {
            $0.color = .mainOrange1
            $0.hidesWhenStopped = true
            
        }
        
        orderedTimeTitleLabel.do {
            $0.isHidden = true
        }
        
        timeBubble.do {
            $0.image = UIImage(named: "TimeBubble.png")
            $0.contentMode = .scaleToFill
            
        }
        //남은 시간 60분 미만일때 말풍선 띄우기 위한 기준값 설정
        
        remainTimeUnderOneHour.do {
            $0.textColor = .white
        }
        // Image 생성
        foodImageView.do{
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.cornerRadius = 13
        }
        
        foodImageIndicator.do {
            $0.color = .mainOrange1
            $0.hidesWhenStopped = true
        }
        // label 생성
        title.do {
            $0.text = "삼첩분식 드실분~ 저는 빨리..."
            $0.textAlignment = .left
        }
        
        separateView.do {
            $0.backgroundColor = .gray0
        }
        
        
        //if just post
        detailBox.do {
            $0.backgroundColor = .clear
        }
        
        closingTimeTitle.do {
            $0.text = "마감시간"
            $0.textColor = .gray2
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 10, weight: .medium)
        }
        
        AMPMLabel.do {
            $0.text = "오후"
            $0.textColor = .mainYellow
            $0.textAlignment = .center
        }
        
        closingTimeValue.do {
            $0.textColor = .mainOrange2
            $0.textAlignment = .center
        }
        
        separateMiddleView.do {
            $0.backgroundColor = .gray0
        }
        
        insufficientChargeTitle.do {
            $0.text = "부족한 금액"
            $0.textColor = .gray2
            $0.textAlignment = .center
        }
        
        insufficientChargeValueLabel.do {
            $0.text  = "0"
            $0.textColor = .mainOrange2
            $0.textAlignment = .center
        }
        
        currency.do {
            $0.text = "원"
            $0.textColor = .mainYellow
            $0.textAlignment = .center
        }

        progressView.do {
            $0.layer.cornerRadius = 5
            $0.progressTintColor = .mainOrange1
            $0.backgroundColor = .gray1
        }
        
        //if order History
        orderHistoryBox.do {
            $0.backgroundColor = .clear
            $0.isHidden = true
        }
        
        orderedTimeLabel.do {
            $0.text = "주문시간"
            $0.textColor = .gray2
        }
        
        orderedPriceLabel.do {
            $0.text = "주문금액"
            $0.textColor = .gray2
        }
        
        orderedTimeValueLabel.do {
            $0.text = "00:00"
            $0.textColor = .gray2
        }
        
        orderedPriceValueLabel.do {
            $0.text = "0"
            $0.textColor = .black
        }
        
        orderedPriceUnitLabel.do {
            $0.text = "원"
            $0.textColor = .gray2
        }
        
        pastLabel.do {
            $0.text = "주문 불가"
            $0.font = .AppleSDGothicNeo(.medium, size: 20)
            $0.textColor = .red
            $0.textAlignment = .center
            $0.baselineAdjustment = .alignCenters
            $0.isHidden = true
            $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
    }
    
    private func addView() {
        contentView.addSubviews([profileImage, profileIndicator, nickNameLabel, userLocation, locationIndicator, orderedTimeTitleLabel, timeBubble])
        timeBubble.addSubview(remainTimeUnderOneHour)
        
        contentView.addSubview(contentBox)
        
        contentBox.addSubviews([foodImageView, foodImageIndicator, title, progressView, detailBox, orderHistoryBox, pastLabel])
        
        detailBox.addSubviews([closingTimeTitle, AMPMLabel, closingTimeValue, separateMiddleView, insufficientChargeTitle, insufficientChargeValueLabel, currency])
        
        orderHistoryBox.addSubviews([separateView, orderedTimeLabel, orderedPriceLabel, orderedTimeValueLabel, orderedPriceValueLabel, orderedPriceUnitLabel])
        
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalToSuperview()
        }
        profileImage.snp.makeConstraints {
            $0.width.equalTo(28)
            $0.height.equalTo(28)
            $0.top.equalToSuperview().offset(11)
            $0.leading.equalToSuperview().offset(19)
        }
        profileIndicator.snp.makeConstraints {
            $0.width.height.equalTo(profileImage)
            $0.center.equalTo(profileImage)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.leading.equalToSuperview().offset(54)
            $0.centerY.equalTo(profileImage)
        }
        
        userLocation.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(21)
            $0.centerY.equalTo(nickNameLabel)
            $0.leading.equalTo(nickNameLabel.snp.trailing).offset(10)
        }
        
        locationIndicator.snp.makeConstraints {
            $0.height.equalTo(userLocation)
            $0.width.equalTo(userLocation.snp.height)
            $0.center.equalTo(userLocation)
        }
        
        orderedTimeTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(11)
        }
        
        timeBubble.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-5)
            $0.leading.equalTo(userLocation.snp.trailing).offset(2)
            $0.height.equalTo(25)
            $0.top.equalTo(userLocation)
        }
        
        remainTimeUnderOneHour.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-3)
            $0.centerX.equalToSuperview()
        }
        
        contentBox.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(121)
            $0.bottom.equalToSuperview()
        }
        
        foodImageView.snp.makeConstraints {
            $0.leading.equalTo(contentBox).offset(16)
            $0.bottom.equalToSuperview().offset(-18)
            $0.width.equalTo(64)
            $0.height.equalTo(86)
        }
        
        foodImageIndicator.snp.makeConstraints {
            $0.center.equalTo(foodImageView)
            $0.width.height.equalTo(foodImageView.snp.width)
        }
        
        title.snp.makeConstraints {
            $0.leading.equalTo(foodImageView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(foodImageView)
        }
        
        detailBox.snp.makeConstraints {
            $0.leading.equalTo(title)
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        separateMiddleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-2)
            $0.width.equalTo(2)
        }
        
        
        closingTimeTitle.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.top.equalTo(separateMiddleView).offset(2)
            $0.trailing.equalTo(separateMiddleView).offset(-30)
        }
        
        AMPMLabel.snp.makeConstraints {
            $0.width.equalTo(19)
            $0.height.equalTo(21)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        closingTimeValue.snp.makeConstraints {
            $0.leading.equalTo(AMPMLabel.snp.trailing).offset(5)
            $0.bottom.equalTo(AMPMLabel)
            $0.height.equalTo(32)
            $0.trailing.equalTo(separateMiddleView.snp.leading).offset(-10)
        }
        
        insufficientChargeTitle.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.leading.equalTo(separateMiddleView.snp.trailing).offset(30)
            $0.top.equalTo(closingTimeTitle)
        }
        
        insufficientChargeValueLabel.snp.makeConstraints {
            $0.centerX.equalTo(insufficientChargeTitle)
            $0.bottom.equalTo(closingTimeValue)
        }
        
        currency.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(21)
            $0.right.equalTo(insufficientChargeValueLabel).offset(15)
            $0.bottom.equalTo(AMPMLabel)
        }
        
        progressView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        orderHistoryBox.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(detailBox)
        }
        
        separateView.snp.makeConstraints {
            $0.leading.equalTo(title)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(title.snp.bottom).offset(5)
            $0.height.equalTo(2)
        }
        orderedTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(title)
            $0.top.equalTo(separateView.snp.bottom).offset(15)
        }
        
        orderedPriceLabel.snp.makeConstraints {
            $0.leading.equalTo(orderedTimeLabel)
            $0.top.equalTo(orderedTimeLabel.snp.bottom).offset(5)
        }
        
        orderedTimeValueLabel.snp.makeConstraints {
            $0.trailing.equalTo(separateView)
            $0.top.equalTo(orderedTimeLabel)
        }
        
        orderedPriceUnitLabel.snp.makeConstraints {
            $0.trailing.equalTo(orderedTimeValueLabel)
            $0.top.equalTo(orderedTimeValueLabel.snp.bottom).offset(5)
        }
        
        orderedPriceValueLabel.snp.makeConstraints {
            $0.top.equalTo(orderedTimeValueLabel.snp.bottom).offset(5)
            $0.trailing.equalTo(orderedPriceUnitLabel.snp.leading).offset(-5)
        }
        
        pastLabel.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    public func setData(data : Datum) {
        dateFormatter.dateFormat = "h:mm"
        profileIndicator.startAnimating()
        if let profileImgUrl = data.user.profileImgUrl {
            self.profileImage.load(url: profileImgUrl) {
                self.profileIndicator.stopAnimating()
            }
        } else {
            self.profileIndicator.stopAnimating()
        }
        
        let mediateTime =  data.post.targetTime + 10800
        remainEpochTime = data.post.targetTime + 10800
        if let nickName = data.user.nickname {
            self.nickNameLabel.text = nickName
        } else {
            self.nickNameLabel.text = "탈퇴한 사용자"
        }
        
        if let id = data.user.id {
            self.userId = id
        }
        
        self.remainTimeUnderOneHour.text = Calculater.calculatedRemainTime(targetTime: mediateTime)
        if self.remainTimeUnderOneHour.text == "주문 시간이 지났습니다" {
            pastLabel.isHidden = false
        } else {
            pastLabel.isHidden = true
        }
        self.AMPMLabel.text = Calculater.setAMPM(closingTime: mediateTime)
        self.title.text = data.post.title
        self.postId = data.post.id
        self.closingTimeValue.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(mediateTime)))
        self.insufficientChargeValueLabel.text = String(data.post.targetPrice).insertComma
        
        
        
        foodImageIndicator.startAnimating()
        self.foodImageView.load(url: data.post.postImgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            self.foodImageIndicator.stopAnimating()
        }
        
        let updateProgressValue = data.post.orderedPrice > data.post.targetTime ? 1.0 : Float (data.post.orderedPrice) / Float(data.post.targetPrice)
        progressView.progress = updateProgressValue
        
        if data.post.status == POST_STATUS.RECRUITING.value {
            // 분기 동작 없음
        }
        
        if data.post.status == POST_STATUS.RECRUIT_SUCCESS.value {
            self.contentView.alpha = 0.5
        }
        
        if data.post.status == POST_STATUS.RECRUIT_FAIL.value {
            self.contentView.alpha = 0.5
        }
        

    }
    public func setHistoryData(data : OrderHistory) {
        changeToHistoryMode()
        dateFormatter.dateFormat        = "yyyy. MM. dd"
        self.orderedTimeTitleLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(data.order.orderedTime)))
        foodImageIndicator.startAnimating()
        self.foodImageView.load(url: data.post.postImgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            self.foodImageIndicator.stopAnimating()
        }
        self.title.text                 = data.post.title
        
        dateFormatter.dateFormat        = "hh:mm"
        self.orderedTimeValueLabel.text     = dateFormatter.string(from: Date(timeIntervalSince1970: Double(data.order.orderedTime)))
        self.orderedPriceValueLabel.text =  String(data.order.orderedPrice).insertComma
        
        self.postId = data.post.id
        self.storeName = data.post.storeName
    }
    
    public func getPostId() -> Int {
        guard let postId = self.postId else { return 0 }
        return postId
    }
    
    public func getStoreName() -> String {
        guard let storeName = self.storeName else { return "가게 이름 정보 없음"}
        return storeName
    }
    private func changeToHistoryMode() {
        profileImage.isHidden           = true
        nickNameLabel.isHidden          = true
        userLocation.isHidden           = true
        timeBubble.isHidden             = true
        progressView.isHidden           = true
        detailBox.isHidden              = true
        
        orderHistoryBox.isHidden        = false
        orderedTimeTitleLabel.isHidden  = false
        
    }
    func setLocation(location : String) {
        DispatchQueue.main.async {
            self.userLocation.text = location
        }
    }
}
