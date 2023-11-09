////
////  ViewController.swift
////  DIVIDE
////
////  Created by 임우섭 on 2022/06/28.
////
//

import NMapsMap
import CoreLocation
import RxSwift
import RxCocoa
import RxGesture
import PhotosUI

final class PostRecruitingViewController: DVIDEViewController2, ViewControllerFoundation, CLLocationManagerDelegate {

    private var viewModel : PostRecruitingBusinessLogic?
    var disposeBag = DisposeBag()
    
    // 사진
    var currentTag : Int!
    var imgArray: [UIImage] = []
    
    // 시간 milliseconds
    var milliseconds : Int?
    
    private let scrollView                      = UIScrollView()
    private let scrollContentView               = UIView()
    
    private let titleLabel                      = MainLabel(type: .Basics5)
    private let storeLabel                      = MainLabel(type: .Basics5)
    private let categoryLabel                   = MainLabel(type: .Basics5)
    private let deliveryFeeLabel                = MainLabel(type: .Basics5)
    private let deliveryFeeUnitLabel            = MainLabel(type: .Point2)
    private let aimUnitLabel                    = MainLabel(type: .Point2)
    private let deliveryAimMoneyLabel           = MainLabel(type: .Basics5)
    private let dueTimeLabel                    = MainLabel(type: .Basics5)
    private let photoLabel                      = MainLabel(type: .Basics5)
    private let photoWarningLabel               = MainLabel(type: .Basics3)
    private let placeLabel                      = MainLabel(type: .Basics5)
    private let contentLabel                    = MainLabel(type: .Basics5)
    
    private let titleTextField                  = MainTextField(type: .main)
    private let storeTextField                  = MainTextField(type: .main)
    private let deliveryFeeTextField            = MainTextField(type: .main)
    private let deliveryAimTextField            = MainTextField(type: .main)
    private let dueTimeTextField                = MainTextField(type: .main)
    
    private let categoryCollectionView          = UICollectionView(frame: .zero, collectionViewLayout: .init())
    var selectedCategoryTag : Int = 0
    private let contentTextView                 = UITextView()
    
    
    
    private let uploadButton                    = MainButton(type: .mainAction)
    
    
    private var photoConfiguration              = PHPickerConfiguration()
    private let imgStackView                    = UIStackView()
    private let imgForUpload1                   = UIImageView()
    private let imgForUpload2                   = UIImageView()
    private let imgForUpload3                   = UIImageView()
    
    // Location
    
    var locationManager = CLLocationManager()
    
    // Naver Maps
    lazy var mapView = NMFNaverMapView(frame: view.frame)
    private let cameraPos = NMFCameraPosition()
    private let markerImg = UIImageView()
    private let markerPointer = UIImageView()
    private let currentPositionButton = UIButton()
    
    //DatePicker 정의
    private let datePicker = UIDatePicker()
    
    private let postIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setAttribute()
        addView()
        setLayout()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        dueTimeTextField.inputView = datePicker
        
        addAction()
    }
    
    internal func setUp() {
        self.viewModel = PostRecruitingViewModel()
        self.contentTextView.delegate = self
    }
    
    internal func setAttribute() {
        view.backgroundColor = .viewBackgroundGray
        

        navigationLabel.do {
            $0.text = "D/VIDE 모집글 작성"
            $0.numberOfLines = 2
        }
        
        scrollView.do {
            $0.backgroundColor = .viewBackgroundGray
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
        scrollContentView.do {
            $0.backgroundColor = .viewBackgroundGray
        }
        
        // Label
        titleLabel.do {
            $0.text = "• 제목"
        }
        storeLabel.do {
            $0.text = "• 가게 이름"
        }
        categoryLabel.do {
            $0.text = "• 카테고리"
        }
        deliveryFeeLabel.do {
            $0.text = "• 배달비"
        }
        deliveryFeeUnitLabel.do {
            $0.text = "원"
            $0.textColor = .unitGray
        }
        aimUnitLabel.do {
            $0.text = "원"
            $0.textColor = .unitGray
        }
        deliveryAimMoneyLabel.do {
            $0.text = "• 목표 금액"
        }
        dueTimeLabel.do {
            $0.text = "• 마감 시간"
        }
        photoLabel.do {
            $0.text = "• 사진"
        }
        photoWarningLabel.do {
            $0.text = "*최대 3장"
        }
        placeLabel.do {
            $0.text = "• 장소"
        }
        contentLabel.do {
            $0.text = "• 내용"
        }
        
        // UITextField
        
        titleTextField.do {
            $0.textFieldTextChanged($0)
            $0.resignFirstResponder()
            $0.textColor = .mainOrange1
        }
        storeTextField.do {
            $0.textFieldTextChanged($0)
            $0.resignFirstResponder()
            $0.textColor = .mainOrange1
        }
        //textfield 대체
        categoryCollectionView.do {
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.minimumLineSpacing = 7
            layout.minimumInteritemSpacing = 7
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.backgroundColor = .viewBackgroundGray
            $0.collectionViewLayout = layout
            $0.register(HomeTopMenuCollectionViewCell.self, forCellWithReuseIdentifier: HomeTopMenuCollectionViewCell.className)
        }
        
        deliveryFeeTextField.do {
            $0.textFieldTextChanged($0)
            $0.keyboardType = .numberPad
            $0.delegate = self
            $0.resignFirstResponder()
            $0.textColor = .mainOrange1
        }
        
        deliveryAimTextField.do {
            $0.textFieldTextChanged($0)
            $0.keyboardType = .numberPad
            $0.delegate = self
            $0.resignFirstResponder()
            $0.textColor = .mainOrange1
        }
        dueTimeTextField.do {
            $0.textFieldTextChanged($0)
            $0.resignFirstResponder()
            $0.textColor = .mainOrange1
        }
        
        //UITextView
        
        contentTextView.do {
            $0.textContainerInset = UIEdgeInsets(top: 18.0, left: 18.0, bottom: 18.0, right: 18.0)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 18
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
            $0.layer.addShadow(location: .all)
            $0.font = UIFont.NotoSansKR(.medium, size: 15)
            $0.textColor = .black
            $0.keyboardType  = .default
            $0.returnKeyType = .done
            
            $0.resignFirstResponder()
        }
        
        // UIButton
       
        
        uploadButton.do {
            $0.setTitle("업로드 하기", for: .normal)
            $0.addTarget(self, action: #selector(post), for: .touchUpInside)
            $0.layer.cornerRadius = 15
        }
        
        // StackView
        imgStackView.do {
            $0.axis = .horizontal
            //        $0.alignment = .fill
            $0.distribution = .equalSpacing
            $0.spacing = 10
        }
        
        // UIImageView
        imgForUpload1.do {
            $0.image = UIImage(named: "defaultPhoto")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 13
        }
        imgForUpload2.do {
            $0.image = UIImage(named: "defaultPhoto")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 13
        }
        imgForUpload3.do {
            $0.image = UIImage(named: "selectPhoto")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 13
        }
        
        // Map 관련
        guard let currentLatitude = locationManager.location?.coordinate.latitude else { return }
        guard let currentLongitude = locationManager.location?.coordinate.longitude else { return }
        mapView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 18
            $0.clipsToBounds = true
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
            $0.layer.addShadow(location: .all)
            $0.showLocationButton = true
            $0.showZoomControls = false
            
            let latlng = NMGLatLng(lat: Double(currentLatitude), lng: Double(currentLongitude))
            let cameraPostion = NMFCameraPosition(latlng, zoom: 15)
            let cameraUpdate = NMFCameraUpdate(position: cameraPostion)
            
            $0.mapView.minZoomLevel = 13
            $0.mapView.moveCamera(cameraUpdate)
        }
        markerImg.do {
            $0.image = UIImage(named: "mSNormalBlue.png")
        }
        markerPointer.do {
            $0.image = UIImage(named: "pointer.png")
        }
        // DatePicker
        datePicker.do {
            $0.preferredDatePickerStyle = .wheels
            $0.minimumDate = .now
            $0.minuteInterval = 5
            $0.datePickerMode = .time
            $0.locale = Locale(identifier: "ko-KR")
            $0.timeZone = .current
            $0.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        }
        
        postIndicator.do {
            $0.color = .mainOrange1
            $0.cornerRadius = 15
        }
    } // then
    
    internal func addView() {
        view.addSubview(scrollView)

        scrollView.addSubview(scrollContentView)
        
        //UILabel add
        scrollContentView.addSubviews([titleLabel, storeLabel, deliveryFeeLabel, deliveryAimMoneyLabel, dueTimeLabel, placeLabel, contentLabel, categoryLabel, photoLabel, photoWarningLabel])
        deliveryFeeTextField.addSubview(deliveryFeeUnitLabel)
        deliveryAimTextField.addSubview(aimUnitLabel)
        
        //UITextField add
        scrollContentView.addSubviews([categoryCollectionView, titleTextField, storeTextField, deliveryFeeTextField, deliveryAimTextField, dueTimeTextField])
        
        // UIView add
        scrollContentView.addSubviews([contentTextView, mapView, postIndicator])
        
        // MapView's subView
        mapView.addSubviews([markerImg, markerPointer])
        
        //UIButton add
        scrollContentView.addSubview(uploadButton)
        
        //UIImageView add
        scrollContentView.addSubview(imgStackView)
        [imgForUpload1, imgForUpload2, imgForUpload3].forEach { img in
            imgStackView.addArrangedSubview(img)
        }
        
        
    } // self.addSubview...
    internal func setLayout() {
        // ScrollView
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.bottom)
        }
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        // Label
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(scrollContentView.snp.leading).offset(26)
            $0.width.equalTo(93)
            $0.centerY.equalTo(titleTextField.snp.centerY)
        }
        storeLabel.snp.makeConstraints {
            $0.leading.equalTo(scrollContentView.snp.leading).offset(26)
            $0.width.equalTo(93)
            $0.centerY.equalTo(storeTextField.snp.centerY)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(scrollContentView.snp.leading).offset(26)
            $0.width.equalTo(93)
            $0.centerY.equalTo(categoryCollectionView.snp.centerY)
        }
        deliveryFeeLabel.snp.makeConstraints {
            $0.leading.equalTo(scrollContentView.snp.leading).offset(26)
            $0.width.equalTo(93)
            $0.centerY.equalTo(deliveryFeeTextField.snp.centerY)
        }
        
        deliveryAimMoneyLabel.snp.makeConstraints {
            $0.leading.equalTo(scrollContentView.snp.leading).offset(26)
            $0.width.equalTo(93)
            $0.centerY.equalTo(deliveryAimTextField.snp.centerY)
        }
        deliveryFeeUnitLabel.snp.makeConstraints {
            $0.trailing.equalTo(deliveryFeeTextField.snp.trailing).offset(-18)
            $0.centerY.equalTo(deliveryFeeTextField.snp.centerY)
        }
        
        aimUnitLabel.snp.makeConstraints {
            $0.trailing.equalTo(deliveryAimTextField.snp.trailing).offset(-18)
            $0.centerY.equalTo(deliveryAimTextField.snp.centerY)
        }
        dueTimeLabel.snp.makeConstraints {
            $0.leading.equalTo(scrollContentView.snp.leading).offset(26)
            $0.width.equalTo(93)
            $0.centerY.equalTo(dueTimeTextField.snp.centerY)
        }
        photoLabel.snp.makeConstraints {
            $0.leading.equalTo(scrollContentView.snp.leading).offset(26)
            $0.width.equalTo(93)
            $0.top.equalTo(imgForUpload1.snp.top).offset(10)
        }
        photoWarningLabel.snp.makeConstraints {
            $0.leading.equalTo(photoLabel)
            $0.top.equalTo(photoLabel.snp.bottom).offset(10)
            $0.width.equalTo(93)
        }
        placeLabel.snp.makeConstraints {
            $0.leading.equalTo(scrollContentView.snp.leading).offset(26)
            $0.width.equalTo(93)
            $0.top.equalTo(mapView.snp.top).offset(7)
        }
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(scrollContentView.snp.leading).offset(26)
            $0.width.equalTo(93)
            $0.top.equalTo(contentTextView.snp.top).offset(7)
        }
        
        //TextField
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(scrollContentView.snp.top).offset(28)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(36)
        }
        storeTextField.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(12)
            $0.leading.equalTo(storeLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(36)
        }
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(storeTextField.snp.bottom).offset(12)
            $0.leading.equalTo(storeLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(67)
        }
        deliveryFeeTextField.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(12)
            $0.leading.equalTo(deliveryFeeLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(36)
        }
        deliveryAimTextField.snp.makeConstraints {
            $0.top.equalTo(deliveryFeeTextField.snp.bottom).offset(12)
            $0.leading.equalTo(deliveryAimMoneyLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(36)
        }
        dueTimeTextField.snp.makeConstraints {
            $0.top.equalTo(deliveryAimTextField.snp.bottom).offset(12)
            $0.leading.equalTo(dueTimeLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(36)
        }
        
        //MapView
        mapView.snp.makeConstraints {
            $0.top.equalTo(imgForUpload1.snp.bottom).offset(17)
            $0.leading.equalTo(placeLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(250)
        }
        markerImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-25)
            $0.height.equalTo(50)
            $0.width.equalTo(35)
        }
        markerPointer.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        
        //UITextView
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(12)
            $0.leading.equalTo(contentLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(178)
        }
        
        //Button
        uploadButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(contentTextView.snp.bottom).offset(20)
            $0.centerX.equalTo(scrollContentView)
            $0.bottom.equalTo(scrollContentView.snp.bottom).offset(-29)
            $0.width.equalTo(scrollContentView.snp.width).inset(20)
        }

        
        //UIImageView
        imgStackView.snp.makeConstraints {
            $0.top.equalTo(dueTimeTextField.snp.bottom).offset(17)
            $0.leading.equalTo(photoLabel.snp.trailing)
        }
        imgForUpload1.snp.makeConstraints {
            $0.height.equalTo(71)
            $0.width.equalTo(71)
        }
        imgForUpload2.snp.makeConstraints {
            $0.height.equalTo(71)
            $0.width.equalTo(71)
        }
        imgForUpload3.snp.makeConstraints {
            $0.height.equalTo(71)
            $0.width.equalTo(71)
        }
        
        postIndicator.snp.makeConstraints {
            $0.height.width.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mapView.snp.top).offset(100)
        }
    }
    
    internal func addAction() {

        imgForUpload3.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self]  _ in
                guard let self = self else { return }
                self.getPhoto()
            }.disposed(by: disposeBag)
    }
 
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h 시 m 분"
        let dateString = dateFormatter.string(from: sender.date)
        milliseconds = Int(sender.date.timeIntervalSince1970) + 32400 //왠지 모르겠지만 9시간이 빠진채로 보내짐...
        self.dueTimeTextField.text = dateString
        self.dueTimeTextField.resignFirstResponder()
    }
    
    @objc func post() {
        print("post")
        
        // Check 1: 있는지 없는지
        if let title = titleTextField.text, let store = storeTextField.text, let deliveryFee = deliveryFeeTextField.text, let targetPrice = deliveryAimTextField.text, let content = contentTextView.text, let targetTime = milliseconds {
            postIndicator.startAnimating()
            postIndicator.backgroundColor = .white
            var imgList : [Data] = []
            imgArray.forEach({ img in
                if let jpegImg = img.jpegData(compressionQuality: 0.5) {
                    imgList.append(jpegImg)
                    print("img List is : \(imgList)")
                } else {
                    print("사진 변환 오류")
                    return
                }
            })
            

            let inputData = PostRecruitingInput(title: title,
                                                storeName: store,
                                                content: content,
                                                targetPrice: Int(targetPrice.split(separator: ",").joined())!,
                                                deliveryPrice: Int(deliveryFee.split(separator: ",").joined())!,
                                                longitude:  self.mapView.mapView.longitude,
                                                latitude:   self.mapView.mapView.latitude,
                                                category: CATEGORIES.allCases[self.selectedCategoryTag].categoryName,
                                                targetTime: targetTime)
            self.viewModel?.requestpostRecruiting(param: inputData, img: imgList) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.postIndicator.stopAnimating()
                        self.postIndicator.backgroundColor = .clear
                    }
                    let destination = PopupViewController()
                    destination.dismissListener = { self.navigationController?.popViewController(animated: true) }
                    destination.modalPresentationStyle = .overFullScreen
                    destination.setPopupMessage(message: "글이 업로드 되었어요! \n 채팅을 확인해 보세요", popupType: .ALERT)
                    
                    self.navigationController?.present(destination, animated: false)
                    
                case .failure(let err):
                    print(err)
                }
            }
        } else {
            self.presentAlert(title: "누락된 정보가 있습니다.")
        }
        
    }
    
    private func getPhoto() {
        photoConfiguration.filter = .any(of: [.images])
        photoConfiguration.selectionLimit = 3
        let picker = PHPickerViewController(configuration: photoConfiguration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}

extension PostRecruitingViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollContentView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                textField.resignFirstResponder()
            }.disposed(by: disposeBag)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // replacementString : 방금 입력된 문자 하나, 붙여넣기 시에는 붙여넣어진 문자열 전체
        // return -> 텍스트가 바뀌어야 한다면 true, 아니라면 false
        // 이 메소드 내에서 textField.text는 현재 입력된 string이 붙기 전의 string
        
        if textField == deliveryFeeTextField || textField == deliveryAimTextField {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal // 1,000,000
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
            
            // formatter.groupingSeparator // .decimal -> ,
            
            if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
                var beforeForemattedString = removeAllSeprator + string
                if formatter.number(from: string) != nil {
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                }else{ // 숫자가 아닐 때
                    if string == "" { // 백스페이스일때
                        let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                        beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                        if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                            textField.text = formattedString
                            return false
                        }
                    } else { // 문자일 때
                        return false
                    }
                }
                
            }
            
            return true
        }
        
        //다른 textField일 때
        return true
    }
    
    
}


extension PostRecruitingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CATEGORIES.allCases.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTopMenuCollectionViewCell", for: indexPath) as! HomeTopMenuCollectionViewCell
        cell.menuLabel.text = CATEGORIES.allCases[indexPath.row].category
        cell.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = categoryCollectionView.cellForItem(at: indexPath) as! HomeTopMenuCollectionViewCell
        self.selectedCategoryTag = cell.tag
        cell.backgroundColor = .mainOrange1
    }
}

extension PostRecruitingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // picker 닫고
        picker.dismiss(animated: true)

        results.forEach { result in
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
                result.itemProvider.loadObject(ofClass: UIImage.self) { (newImage, error) in // 4
                    let newImage = newImage as! UIImage
                    if self.imgArray.isEmpty {
                        self.imgArray.append(newImage)
                        DispatchQueue.main.async {
                            self.imgForUpload1.image = newImage
                        }
                        // 받아온 이미지를 update
                    } else if self.imgArray.count == 1 {
                        self.imgArray.append(newImage)
                        DispatchQueue.main.async {
                            self.imgForUpload2.image = newImage
                        }
                    } else if self.imgArray.count == 2 {
                        self.imgArray.append(newImage)
                        DispatchQueue.main.async {
                            self.imgForUpload3.image = newImage
                        }
                    } else {
                        self.imgArray.remove(at: 0)
                        DispatchQueue.main.async {
                            self.imgForUpload1.image = self.imgForUpload2.image
                            self.imgForUpload2.image = self.imgForUpload3.image
                            self.imgForUpload3.image = newImage
                        }
                        self.imgArray.append(newImage)
                    }
                }
            } else {
                // TODO: Handle empty results or item provider not being able load UIImage
                print("가져온 사진이 없음")
            }
        }
        
    }
}

extension PostRecruitingViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollContentView.frame.origin.y -= 200
        self.scrollContentView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                textView.resignFirstResponder()
            }.disposed(by: disposeBag)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.scrollContentView.frame.origin.y += 200
    }
    
}

