//
//  PostReviewViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/08.
//

import Cosmos
import PhotosUI
import RxGesture
import RxSwift

final class PostReviewViewController: DVIDEViewController2, ViewControllerFoundation {

    private var postId : Int?
    private var viewModel : PostReviewBesinessLogic?
    
    private let storeLabel              = MainLabel(type: .Basics5)
    private let starRatingLabel         = MainLabel(type: .Basics5)
    private let photoLabel              = MainLabel(type: .Basics5)
    private let contentLabel            = MainLabel(type: .Basics5)

    private let storeTextField          = MainTextField(type: .main)
    private let ratingBackgroundView    = UIView()
    private let rating                  = CosmosView()
    private let imageStackView          = UIStackView()
    private let imageForUpload1         = UIImageView()
    private let imageForUpload2         = UIImageView()
    private let imageForUpload3         = UIImageView()
    private let contentTextView         = UITextView()
    private let uploadButton            = MainButton(type: .mainAction)
    
    
    private var disposeBag              = DisposeBag()
    private var photoConfiguration      = PHPickerConfiguration()
    private var imageArray: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setAttribute()
        addView()
        setLayout()
        addAction()
    }
    
    internal func setUp() {
        self.viewModel = PostReviewViewModel()
    }
    
    internal func setAttribute(){
        navigationLabel.do {
            $0.text = "후기 작성"
        }
        
        storeLabel.do {
            $0.text = "• 가게 이름"
        }

        starRatingLabel.do {
            $0.text = "• 별점"
        }
        
        photoLabel.do {
            $0.text = "• 사진"
        }
        
        contentLabel.do {
            $0.text = "• 내용"
        }
        
        storeTextField.do {
            $0.isUserInteractionEnabled = false
            $0.textColor = .black
        }
        
        ratingBackgroundView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 18
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
            $0.layer.addShadow(location: .all)
        }
        
        rating.do {
            $0.settings.fillMode        = .precise
            $0.settings.updateOnTouch   = true
            $0.settings.starSize        = 28
            $0.settings.filledImage     = UIImage(named: "filledStar")
            $0.settings.emptyImage      = UIImage(named: "unfilledStar")
            $0.settings.starMargin      = 5
            $0.settings.filledColor     = .mainOrange1
            $0.settings.emptyColor      = .viewBackgroundGray
        }
        
        contentTextView.do {
            $0.backgroundColor          = .white
            $0.layer.cornerRadius       = 18
            $0.layer.maskedCorners      = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
            $0.layer                      .addShadow(location: .all)
            $0.font                     = UIFont.NotoSansKR(.medium, size: 15)
            $0.textColor                = .black
            $0.returnKeyType            = .done
            $0.tintColor                = .mainOrange1
            $0.delegate                 = self
        }
        
        imageStackView.do {
            $0.axis = .horizontal
            //        $0.alignment = .fill
            $0.distribution = .equalSpacing
            $0.spacing = 10
        }
        
        // UIImageView
        imageForUpload1.do {
            $0.image = UIImage(named: "defaultPhoto")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 13
        }
        imageForUpload2.do {
            $0.image = UIImage(named: "defaultPhoto")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 13
        }
        imageForUpload3.do {
            $0.image = UIImage(named: "selectPhoto")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 13
        }
        
        uploadButton.do {
            $0.setTitle("업로드하기", for: .normal)
        }
    }
    
    internal func addView(){
        view.addSubviews([storeLabel, starRatingLabel, photoLabel, contentLabel])
        view.addSubviews([storeTextField, ratingBackgroundView, imageStackView, contentTextView])
        
        ratingBackgroundView.addSubview(rating)
        
        [imageForUpload1, imageForUpload2, imageForUpload3].forEach { img in
            imageStackView.addArrangedSubview(img)
        }
        view.addSubview(uploadButton)
    }
    
    internal func setLayout(){
        storeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(21)
            $0.top.equalTo(navigationView.snp.bottom).offset(30)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }

        starRatingLabel.snp.makeConstraints {
            $0.leading.equalTo(storeLabel)
            $0.top.equalTo(storeLabel.snp.top).offset(59)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        
        photoLabel.snp.makeConstraints {
            $0.leading.equalTo(starRatingLabel)
            $0.top.equalTo(starRatingLabel.snp.top).offset(59)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(photoLabel)
            $0.top.equalTo(photoLabel.snp.top).offset(83)
            $0.width.equalTo(80)
            $0.height.equalTo(30)
        }
        
        storeTextField.snp.makeConstraints {
            $0.leading.equalTo(storeLabel.snp.trailing)
            $0.trailing.equalToSuperview().offset(-21)
            $0.centerY.equalTo(storeLabel)
            $0.height.equalTo(50)
        }
        
        ratingBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalTo(storeTextField)
            $0.top.equalTo(storeTextField.snp.bottom).offset(9)
            $0.height.equalTo(50)
        }
        
        rating.snp.makeConstraints {
            $0.center.equalTo(ratingBackgroundView)
            $0.height.equalTo(28)
            $0.width.equalTo(180)
        }
        
        imageStackView.snp.makeConstraints {
            $0.top.equalTo(ratingBackgroundView.snp.bottom).offset(12)
            $0.leading.equalTo(ratingBackgroundView)
            $0.trailing.equalTo(ratingBackgroundView)
        }
        
        imageForUpload1.snp.makeConstraints {
            $0.height.equalTo(71)
            $0.width.equalTo(71)
        }
        
        imageForUpload2.snp.makeConstraints {
            $0.height.equalTo(71)
            $0.width.equalTo(71)
        }
        
        imageForUpload3.snp.makeConstraints {
            $0.height.equalTo(71)
            $0.width.equalTo(71)
        }
        
        uploadButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
            $0.bottom.equalToSuperview().offset(-25)
            $0.height.equalTo(50)
        }
        contentTextView.snp.makeConstraints {
            $0.leading.equalTo(ratingBackgroundView)
            $0.trailing.equalTo(ratingBackgroundView)
            $0.top.equalTo(imageStackView.snp.bottom).offset(20)
            $0.bottom.equalTo(uploadButton.snp.top).offset(-20)
        }
    }
    
    internal func addAction() {
        backButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        
        imageForUpload3.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self]  _ in
                guard let self = self else { return }
                self.getPhoto()
            }.disposed(by: disposeBag)
        
        uploadButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            
//            guard let postId = self.postId else { return }
            
            // test
            let testReviewModel = PostReviewModel(postId: 3055, starRating: rating.rating, content: contentTextView.text)
            var imageDataList : [Data] = []
            imageArray.forEach { image in
                if let jpegImage = image.jpegData(compressionQuality: 0.5) {
                    imageDataList.append(jpegImage)
                    print("iamge List is : \(imageDataList)")
                } else {
                    print("사진 변환 및 압축 오류")
                    return
                }
            }
            
            viewModel?.postReview(postReviewModel: testReviewModel, img: imageDataList) { [weak self] response in
                switch response {
                case .success(let response):
                    self?.presentAlert(title: "리뷰 등록 성공 : \(response.reviewId)")
                case .failure(let err):
                    print(err)
                }
            }
        }), for: .touchUpInside)
    }
    
    private func getPhoto() {
        photoConfiguration.filter = .any(of: [.images])
        photoConfiguration.selectionLimit = 3
        let picker = PHPickerViewController(configuration: photoConfiguration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    public func setData(postId : Int, storeName : String) {
        self.postId = postId
        print("리뷰 쓸 Post의 Id : ", postId)
        self.storeTextField.text = storeName
    }
    
    
}


extension PostReviewViewController : UITextFieldDelegate {
    
}

extension PostReviewViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      if (text == "\n") {
        textView.resignFirstResponder()
      }
      return true
    }
}

extension PostReviewViewController : PHPickerViewControllerDelegate {
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
                            self.imageForUpload1.image = newImage
                        }
                        // 받아온 이미지를 update
                    } else if self.imageArray.count == 1 {
                        self.imageArray.append(newImage)
                        DispatchQueue.main.async {
                            self.imageForUpload2.image = newImage
                        }
                    } else if self.imageArray.count == 2 {
                        self.imageArray.append(newImage)
                        DispatchQueue.main.async {
                            self.imageForUpload3.image = newImage
                        }
                    } else {
                        self.imageArray.remove(at: 0)
                        DispatchQueue.main.async {
                            self.imageForUpload1.image = self.imageForUpload2.image
                            self.imageForUpload2.image = self.imageForUpload3.image
                            self.imageForUpload3.image = newImage
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


