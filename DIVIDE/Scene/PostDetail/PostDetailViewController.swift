//
//  PostDetailViewController.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/08/19.
//

import UIKit
import RxSwift
import RxGesture
import NMapsMap
import PhotosUI

final class PostDetailViewController: UIViewController, ViewControllerFoundation, UIScrollViewDelegate {
    
    // MARK: property
    private var imageArray : [UIImage]          = []
    private var photoConfiguration              = PHPickerConfiguration()
    private let chatRoomStream                  = ChatRoomFirestoreStream()

    // MARK: components
    private let topBackground                   = UIView()
    private let proposerImage                   = UIImageView()
    private let proposerImageIndicator          = UIActivityIndicatorView()
    private let proposerNickName                = MainLabel(type: .Basics5)
    private let proposerDetailTouchBox          = UIView()
    private let closeButton                     = UIButton(configuration: UIButton.Configuration.filled())
    private let mainScrollView                  = UIScrollView()
    
    private let foodImageView                   = UIImageView()
    private let foodImageIndicator              = UIActivityIndicatorView()
    
    private let informationView                 = UIView()
    private let titleLabel                      = MainLabel(type: .Big1)
    private let dueTimeLabel                    = MainLabel(type: .Point4)
    private let dueTime                         = MainLabel(type: .Point4)
    private let AMPM                            = MainLabel(type: .Basics2)
    
    
    private let deliveryFeeLabel                = MainLabel(type: .Point4)
    private let deliveryFee                     = MainLabel(type: .Point4)
    private let deliveryFeeUnitLabel            = MainLabel(type: .Basics2)
    
    private let deliveryAimMoneyLabel           = MainLabel(type: .Point4)
    private let deliveryAimMoney                = MainLabel(type: .Big1)
    private let aimUnitLabel                    = MainLabel(type: .Basics2)
    
    private let presentOrderMoneyLabel          = MainLabel(type: .Point4)
    private let presentOrderMoney               = MainLabel(type: .Big1)
    private let presentUnitLabel                = MainLabel(type: .Basics2)
    
    private let progressBarBackground           = UIView()
    
    private let progressBar                     = UIView()
    
    private let contentLabel                    = MainLabel(type: .Point4)
    private let content                         = MainLabel(type: .Basics4)
    
    private let placeLabel                      = MainLabel(type: .Point4)
    private let mapContainerView                = UIView()
    lazy var mapView                            = NMFMapView(frame: view.frame)
    private var marker                          = NMFMarker()
    
    
    private let joinButton                      = MainButton(type: .mainAction)
    
    
    // 주문 생성에 필요
    var postId : Int?
    private var postUserId : Int?
    private var postTitle  : String?
    private var postImgUrl : String?
    private var otherNickname : String?
    // bottom sheet
    private let bottomSheetView                 = UIView()
    private let orderMenuLabel                  = MainLabel(type: .Big2)
    private let orderShopLabel                  = MainLabel(type: .Point4)
    
    private let orderImageView1                 = UIImageView()
    private let orderImageView2                 = UIImageView()
    
    private let orderAmountLabel                = MainLabel(type: .Big2)
    private let orderAmountValueTextField       = MainTextField(type: .color)
    private let orderAmountFeeLabel             = MainLabel(type: .Point3)
    private let chatWithDIVIDERButton           = MainButton(type: .mainAction)
    
    private var viewModel : PostDetailBusinessLogic?
    private var disposeBag = DisposeBag()
    // MARK: viewLoaded
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScrollView.delegate = self
        
        setAttribute()
        addView()
        setLayout()
        setNaverMap()
        
        setUp()
        bindToViewModel()
        addAction()
    }
    
    internal func setAttribute() {
        self.view.backgroundColor = .white
        
        topBackground.do {
            $0.backgroundColor = .mainOrange1
        }
        
        proposerImage.do {
            $0.sizeToFit()
            $0.cornerRadius = 20
            $0.backgroundColor = .white
        }
        
        proposerImageIndicator.do {
            $0.color = .mainOrange1
        }
        
        proposerNickName.do {
            $0.text = "NICKNAME"
            $0.textColor = .white
        }
        
        closeButton.do {
            $0.setImage(UIImage(systemName: "xmark"), for: .normal)
            $0.tintColor = .clear
            $0.backgroundColor = .clear
        }
        
        mainScrollView.do {
            $0.backgroundColor = .white
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = true
        }
        
        foodImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.cornerRadius = 10
        }
        
        foodImageIndicator.do {
            $0.color = .mainOrange1
        }
        
        informationView.do {
            $0.backgroundColor = .white
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.do {
            $0.text = "교촌치킨 드실 분~"
            $0.textColor = .black
        }
        
        dueTimeLabel.do {
            $0.text = "• 마감 시간"
            $0.textColor = .gray3
        }
        dueTime.do {
            $0.text = "04:00"
            $0.textColor = .gray3
        }
        AMPM.do {
            $0.text = "PM"
            $0.textColor = .unitGray
        }
        
        deliveryFeeLabel.do {
            $0.text = "• 배달비"
            $0.textColor = .gray3
        }
        deliveryFee.do {
            $0.text = "---"
            $0.textColor = .gray3
        }
        deliveryFeeUnitLabel.do {
            $0.text = "원"
            $0.textColor = .unitGray
        }
        
        deliveryAimMoneyLabel.do {
            $0.text = "• 목표 주문 금액"
            $0.textColor = .gray3
        }
        
        deliveryAimMoney.do {
            $0.text = "---"
            $0.textColor = .mainOrange1
        }
        
        aimUnitLabel.do {
            $0.text = "원"
            $0.textColor = .unitGray
        }
        
        presentOrderMoneyLabel.do {
            $0.text = "• 현재 주문 금액"
            $0.textColor = .gray3
        }
        presentOrderMoney.do {
            $0.text = "---"
            $0.textColor = .mainOrange1
        }
        presentUnitLabel.do {
            $0.text = "원"
            $0.textColor = .unitGray
        }
        
        progressBarBackground.do {
            $0.backgroundColor = .gray
            $0.cornerRadius = 8
        }
        
        progressBar.do {
            $0.backgroundColor = .mainOrange2
            $0.cornerRadius = 8
        }
        
        contentLabel.do {
            $0.text = "• 내용"
        }
        
        content.do {
            $0.backgroundColor = .white
            $0.numberOfLines = 5
        }
        
        placeLabel.do {
            $0.text = "• 장소"
        }
        
        mapContainerView.do {
            $0.backgroundColor = .blue
        }
        
        joinButton.do {
            $0.setTitle("참여하기", for: .normal)
        }
        
        //bottom sheet view
        bottomSheetView.do {
            $0.roundCorners(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            $0.backgroundColor = .white
            $0.layer.addBorder([.top], color: .borderGray, width: 1)
            $0.layer.addShadow(location: .top)
        }
        
        orderMenuLabel.do {
            $0.text = "주문 메뉴"
        }
        
        orderShopLabel.do {
            $0.textColor = .mainOrange1
            $0.text = "삼첩분식(한남점)"
        }
        
        orderImageView1.do {
            $0.image = UIImage(named: "postPhotoDefault")
            $0.contentMode = .scaleAspectFit
        }
        
        orderImageView2.do {
            $0.image = UIImage(named: "postPhotoSelect")
            $0.contentMode = .scaleAspectFit
        }
        
        
        orderAmountLabel.do {
            $0.text = "총 주문 금액"
        }
        
        orderAmountValueTextField.do {
            $0.textAlignment = .right
            $0.text = "0"
            $0.textColor = .mainOrange1
            $0.returnKeyType = .done
            $0.keyboardType = .numbersAndPunctuation
        }
        
        orderAmountFeeLabel.do {
            $0.text = "원"
            $0.textColor = .mainYellow
        }
        
        chatWithDIVIDERButton.do {
            $0.setTitle("D/VIDER와 대화하기", for: .normal)
        }
        
    }
    internal func addView() {
        self.view.addSubviews([topBackground, mainScrollView, proposerImage, proposerImageIndicator, proposerNickName, closeButton, bottomSheetView, proposerDetailTouchBox])
        mainScrollView.addSubviews([foodImageView, foodImageIndicator, informationView])
        informationView.addSubviews([titleLabel,
                                     dueTimeLabel,
                                     dueTime,
                                     AMPM,
                                     deliveryFeeLabel,
                                     deliveryFee,
                                     deliveryFeeUnitLabel,
                                     deliveryAimMoneyLabel,
                                     deliveryAimMoney,
                                     aimUnitLabel,
                                     presentOrderMoneyLabel,
                                     presentOrderMoney,
                                     presentUnitLabel,
                                     progressBarBackground,
                                     progressBar,
                                     contentLabel,
                                     content,
                                     placeLabel,
                                     mapContainerView,
                                     joinButton])
        bottomSheetView.addSubviews([orderMenuLabel, orderShopLabel, orderImageView1, orderImageView2, orderAmountLabel, orderAmountValueTextField, orderAmountFeeLabel, chatWithDIVIDERButton])
    }
    internal func setLayout() {
        // subview of self.view
        topBackground.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(55)
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
        
        mainScrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        proposerImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(35)
            $0.width.equalTo(38)
            $0.height.equalTo(38)
        }
        
        proposerImageIndicator.snp.makeConstraints {
            $0.width.height.equalTo(proposerImage)
            $0.center.equalTo(proposerImage)
        }
        
        proposerNickName.snp.makeConstraints {
            $0.top.equalTo(proposerImage)
            $0.leading.equalTo(proposerImage).offset(44)
            $0.width.equalTo(150)
            $0.height.equalTo(38)
        }
        
        proposerDetailTouchBox.snp.makeConstraints {
            $0.leading.equalTo(proposerImage)
            $0.trailing.equalTo(proposerNickName)
            $0.top.equalTo(proposerImage)
            $0.bottom.equalTo(proposerImage)
        }
        
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(topBackground)
            $0.width.height.equalTo(50)
        }
        
        // subview of mainScrollView
        foodImageView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(250)
            $0.top.equalToSuperview().offset(10)
        }
        
        foodImageIndicator.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.center.equalTo(foodImageView)
        }
        
        informationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(foodImageView.snp.bottom).offset(10)
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview().offset(100)
        }
        
        // subview of informationView
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(171)
            $0.height.equalTo(32)
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(25)
        }
        
        dueTimeLabel.snp.makeConstraints {
            $0.width.equalTo(89)
            $0.height.equalTo(23)
            $0.top.equalToSuperview().offset(90)
            $0.leading.equalToSuperview().offset(30)
        }
        
        dueTime.snp.makeConstraints {
            $0.width.equalTo(54)
            $0.height.equalTo(23)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalToSuperview().offset(90)
        }
        
        AMPM.snp.makeConstraints {
            $0.width.equalTo(29)
            $0.height.equalTo(21)
            $0.trailing.equalToSuperview().offset(-7)
            $0.top.equalToSuperview().offset(92)
        }
        
        deliveryFeeLabel.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(23)
            $0.leading.equalTo(dueTimeLabel)
            $0.top.equalTo(dueTimeLabel).offset(35)
        }
        
        deliveryFee.snp.makeConstraints {
            $0.width.equalTo(63)
            $0.height.equalTo(23)
            $0.trailing.equalTo(dueTime)
            $0.centerY.equalTo(deliveryFeeLabel)
        }
        
        deliveryFeeUnitLabel.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(21)
            $0.trailing.equalToSuperview().offset(-18)
            $0.centerY.equalTo(deliveryFee)
        }
        
        deliveryAimMoneyLabel.snp.makeConstraints {
            $0.width.equalTo(107)
            $0.height.equalTo(23)
            $0.leading.equalTo(deliveryFeeLabel)
            $0.top.equalTo(deliveryFeeLabel).offset(46)
        }
        
        deliveryAimMoney.snp.makeConstraints {
            $0.width.equalTo(86)
            $0.height.equalTo(32)
            $0.trailing.equalTo(deliveryFee).offset(5)
            $0.centerY.equalTo(deliveryAimMoneyLabel)
        }
        
        aimUnitLabel.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(21)
            $0.trailing.equalTo(deliveryFeeUnitLabel)
            $0.centerY.equalTo(deliveryAimMoney).offset(2)
        }
        
        presentOrderMoneyLabel.snp.makeConstraints {
            $0.width.equalTo(deliveryAimMoneyLabel)
            $0.height.equalTo(deliveryAimMoneyLabel)
            $0.trailing.equalTo(deliveryAimMoneyLabel)
            $0.top.equalTo(deliveryAimMoneyLabel).offset(37)
        }
        
        presentOrderMoney.snp.makeConstraints {
            $0.width.equalTo(deliveryAimMoney)
            $0.height.equalTo(deliveryAimMoney)
            $0.leading.equalTo(deliveryAimMoney)
            $0.centerY.equalTo(presentOrderMoneyLabel)
        }
        
        presentUnitLabel.snp.makeConstraints {
            $0.width.equalTo(aimUnitLabel)
            $0.height.equalTo(aimUnitLabel)
            $0.trailing.equalTo(aimUnitLabel)
            $0.centerY.equalTo(presentOrderMoney).offset(2)
        }
        
        progressBarBackground.snp.makeConstraints {
            $0.width.equalTo(320)
            $0.height.equalTo(16)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(presentOrderMoneyLabel).offset(40)
        }
        
        progressBar.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(16)
            $0.leading.equalTo(progressBarBackground)
            $0.top.equalTo(progressBarBackground)
        }
        
        contentLabel.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(23)
            $0.leading.equalTo(presentOrderMoneyLabel)
            $0.top.equalTo(presentOrderMoneyLabel).offset(71)
        }
        
        content.snp.makeConstraints {
            $0.leading.equalTo(contentLabel).offset(10)
            $0.top.equalTo(contentLabel).offset(39)
            $0.width.equalTo(288)
            $0.height.equalTo(20)
        }
        
        placeLabel.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(23)
            $0.leading.equalTo(presentOrderMoneyLabel)
            $0.top.equalTo(content).offset(124)
        }
        
        mapContainerView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(300)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(placeLabel.snp.bottom).offset(20)
        }
        
        joinButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(mapContainerView.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
        
        //bottom sheet
        bottomSheetView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(self.view.snp.bottom)
            $0.height.equalTo(587)
        }
        
        orderMenuLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(20)
        }
        
        orderShopLabel.snp.makeConstraints {
            $0.leading.equalTo(orderMenuLabel)
            $0.top.equalTo(orderMenuLabel.snp.bottom).offset(20)
        }
        
        orderImageView1.snp.makeConstraints {
            $0.leading.equalTo(orderShopLabel)
            $0.top.equalTo(orderShopLabel.snp.bottom).offset(20)
            $0.height.equalTo(263)
            $0.width.equalTo(150)
        }
        
        orderImageView2.snp.makeConstraints {
            $0.top.equalTo(orderImageView1)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(263)
            $0.width.equalTo(150)
        }
        
        orderAmountLabel.snp.makeConstraints {
            $0.leading.equalTo(orderImageView1)
            $0.top.equalTo(orderImageView1.snp.bottom).offset(35)
            $0.width.greaterThanOrEqualTo(102)
            $0.height.greaterThanOrEqualTo(29)
        }
        
        orderAmountValueTextField.snp.makeConstraints {
            $0.trailing.equalTo(orderImageView2).offset(-45)
            $0.top.equalTo(orderImageView2.snp.bottom).offset(35)
            $0.width.greaterThanOrEqualTo(154)
            $0.height.greaterThanOrEqualTo(5)
        }
        
        orderAmountFeeLabel.snp.makeConstraints {
            $0.trailing.equalTo(orderImageView2.snp.trailing).offset(-10)
            $0.centerY.equalTo(orderAmountValueTextField)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        chatWithDIVIDERButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
        
        mainScrollView.contentSize = CGSize(width: mainScrollView.bounds.width, height: mainScrollView.bounds.height + 1250)
    }
    
    /// 네이버 맵 설정 관련 메소드
    ///
    /// containerView에  AutoLayout 적용
    private func setNaverMap() {
        mapContainerView.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.leading.trailing.bottom.top.equalTo(mapContainerView)
        }
    }
    
    internal func setUp() {
        self.viewModel = PostDetailViewModel()
        self.orderAmountValueTextField.delegate = self
    }
    private func bindToViewModel() {
        guard let postId = self.postId else { return }
        self.proposerImageIndicator.startAnimating()
        self.foodImageIndicator.startAnimating()
        viewModel?.requestPostDetail(postId: postId)
            .asObservable()
            .subscribe(onNext: { [weak self] postDetailData in
                guard let self = self else { return }
                if let proposerImageUrl = postDetailData.data?.user?.profileImgUrl {
                        self.proposerImage.load(url: proposerImageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                            self.proposerImageIndicator.stopAnimating()
                        }
                }
                self.proposerNickName.text = postDetailData.data?.user?.nickname
                
                if let foodImageUrl = postDetailData.data?.postDetail?.postImgUrls {
                    self.postImgUrl = foodImageUrl[0]
                    //우선은 첫번째 사진만 로드...
                    self.foodImageView.load(url: foodImageUrl[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                            self.foodImageIndicator.stopAnimating()
                        }
                }
                self.titleLabel.text = postDetailData.data?.postDetail?.title
                self.deliveryFee.text = String(postDetailData.data?.postDetail?.deliveryPrice ?? 0)
                self.deliveryAimMoney.text = String(postDetailData.data?.postDetail?.targetPrice ?? 0)
                self.presentOrderMoney.text = String(postDetailData.data?.postDetail?.orderedPrice ?? 0)
                self.content.text = postDetailData.data?.postDetail?.content
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: postDetailData.data?.postDetail?.latitude ?? 37.59, lng: postDetailData.data?.postDetail?.longitude ?? 126.97))
                cameraUpdate.animation = .none
                cameraUpdate.animationDuration = 0
                self.mapView.moveCamera(cameraUpdate)
                if let lat = postDetailData.data?.postDetail?.latitude, let lng = postDetailData.data?.postDetail?.longitude {
                    self.marker.position = NMGLatLng(lat: lat, lng: lng)
                    self.marker.mapView = self.mapView
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm"
                self.dueTime.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double((postDetailData.data?.postDetail?.targetTime)! + 10800))) //설정값이 3시간 조정필요
                self.AMPM.text = Calculater.setAMPM(closingTime: (postDetailData.data?.postDetail?.targetTime)! + 10800)
                self.orderShopLabel.text = postDetailData.data?.postDetail?.storeName
                self.postUserId = postDetailData.data?.user?.id
                self.postTitle = postDetailData.data?.postDetail?.title
                self.otherNickname = postDetailData.data?.user?.nickname
            }, onError: { error in
                print("========================")
                print("     구독 에러 발생")
                print(error.localizedDescription)
                print("========================")
            }).disposed(by: self.disposeBag)
    }
    
    /// addAction은 iOS 14 이상사용 가능
    ///
    /// joinButton 누르면 주문서 작성 bottom sheet 등장
    internal func addAction() {
        proposerDetailTouchBox.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                let destination = OtherProfileViewController()
                destination.modalPresentationStyle = .pageSheet
                destination.userId = self?.postUserId
                self?.navigationController?.present(destination, animated: true)
            }.disposed(by: disposeBag)
        self.joinButton.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }

            self.bottomSheetView.snp.removeConstraints()
            self.informationView.layer.opacity = 0.4
            
            
            UIView.animate(withDuration: 0.3) {
                self.bottomSheetView.snp.updateConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.bottom.equalToSuperview()
                    $0.height.equalTo(587)
                }
            }
        }), for: .touchUpInside)
        
        self.closeButton.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        
        self.mainScrollView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.bottomSheetView.snp.removeConstraints()
                self.informationView.layer.opacity = 1
                UIView.animate(withDuration: 0.3) {
                    self.bottomSheetView.snp.updateConstraints {
                        $0.leading.trailing.equalToSuperview()
                        $0.top.equalTo(self.view.snp.bottom)
                        $0.height.equalTo(587)
                    }
                }
            }.disposed(by: self.disposeBag)
        
        self.orderImageView2.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.getPhoto()
            }.disposed(by: self.disposeBag)
        
        self.chatWithDIVIDERButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            if let postId = self.postId, let orderPrice = self.orderAmountValueTextField.text {
                
                var imageList : [Data] = []
                self.imageArray.forEach({ image in
                    if let jpegImg = image.jpegData(compressionQuality: 0.5) {
                        imageList.append(jpegImg)
                        print("img List is : \(imageList)")
                    } else {
                        print("사진 변환 오류")
                        return
                    }
                })

                let joinOrder = JoinOrderModel(postId: postId, orderPrice: Int(orderPrice)!)
                self.viewModel?.joinOrder(joinOrder: joinOrder, images: imageList) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let result):
                        let destination = PopupViewController()
                        destination.dismissListener = {
                            self.navigationController?.popViewController(animated: true)
                        }
                        destination.setPopupMessage(message: "디바이드 참여 완료! \n 디바이더와 채팅을 시작하세요!", popupType: .ALERT)
                        // 주문 번호를 가지고 채팅방 id로 사용..?
                        
                        chatRoomStream.createChatRoom(postId: postId,
                                                      title: self.postTitle!,
                                                      foodImgUrl: self.postImgUrl!,
                                                      divider: self.postUserId!,
                                                      me: UserDefaultsManager.userId!,
                                                      userNickname: self.otherNickname!,
                                                      orderId: result.orderId)
                        destination.modalPresentationStyle = .overFullScreen
                        self.navigationController?.present(destination, animated: true)
                    case .failure(let err):
                        print(err)
                    }
                }
                 
            } else {
                self.presentAlert(title: "누락된 정보가 있습니다.")
            }
        }), for: .touchUpInside)
    }
    
    private func getPhoto() {
        photoConfiguration.filter = .any(of: [.images])
        photoConfiguration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: photoConfiguration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func setPostId(postId : Int) {
        self.postId = postId
    }
}


extension PostDetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // picker 닫고
        picker.dismiss(animated: true)
        
        results.forEach { result in
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
                result.itemProvider.loadObject(ofClass: UIImage.self) { (newImage, error) in // 4
                    let newImage = newImage as! UIImage
                    if self.imageArray.isEmpty {
                        self.imageArray.append(newImage)
                        DispatchQueue.main.async {
                            self.orderImageView1.image = newImage
                        }
                        // 받아온 이미지를 update
                    } else if self.imageArray.count == 1 {
                        self.imageArray.append(newImage)
                        DispatchQueue.main.async {
                            self.orderImageView2.image = newImage
                        }
                    } else {
                        self.imageArray.remove(at: 0)
                        DispatchQueue.main.async {
                            self.orderImageView1.image = self.orderImageView2.image
                            self.orderImageView2.image = newImage
                        }
                        self.imageArray.append(newImage)
                    }
                }
            } else {
                // TODO: Handle empty results or item provider not being able load UIImage
                print("가져온 사진이 없음")
            }
        }
        
    }
}

extension PostDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            print(text)
            if text.isOnlyNumber() {
                print("숫자만 잘 적었군")
                self.orderAmountValueTextField.resignFirstResponder()
            } else {
                self.presentAlert(title: "숫자만 입력해 주세요.")
                print("글자가 포함되어 있는디")
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.orderAmountValueTextField.snp.removeConstraints()
        self.orderAmountValueTextField.snp.makeConstraints {
            $0.center.equalTo(self.view)
            $0.width.equalTo(SIZE.width - 60)
            $0.height.equalTo(50)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.orderAmountValueTextField.snp.removeConstraints()
        self.orderAmountValueTextField.snp.makeConstraints {
            $0.trailing.equalTo(orderImageView2).offset(-45)
            $0.top.equalTo(orderImageView2.snp.bottom).offset(35)
            $0.width.greaterThanOrEqualTo(154)
            $0.height.greaterThanOrEqualTo(5)
        }
    }
}

