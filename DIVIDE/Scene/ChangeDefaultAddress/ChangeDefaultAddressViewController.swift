//
//  ChangeDefaultAddressViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/03.
//

import NMapsMap
import RxSwift
import RxGesture
import Moya

final class ChangeDefaultAddressViewController: DVIDEViewController2, ViewControllerFoundation {
        
    private let contentView = UIView()
    lazy var mapView = NMFNaverMapView(frame: view.frame)
    private let cameraPos = NMFCameraPosition()
    private let markerImg = UIImageView()

    private let searchTextField = UITextField()
    private let titleAddressLabel = MainLabel(type: .Basics5)
    private let detailAddressLabel = MainLabel(type: .Basics2)
    
    private let changeAddressButton = MainButton(type: .mainAction)
    
    private var locationManager = CLLocationManager()
    private var disposeBag = DisposeBag()
    private var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        addView()
        setLayout()
        addAction()
    }
    
    internal func setUp() {
        
    }
    internal func setAttribute() {
        view.backgroundColor = .viewBackgroundGray

        navigationLabel.do {
            $0.text = "위치 등록"
        }

        changeAddressButton.do {
            $0.setTitle("주소 설정 완료", for: .normal)
        }
        
        contentView.do {
            $0.backgroundColor = .white
        }
        
        mapView.do {
            if let latlng = getCurrentLocation() {
                let cameraPostion = NMFCameraPosition(latlng, zoom: 15)
                let cameraUpdate = NMFCameraUpdate(position: cameraPostion)
                $0.mapView.moveCamera(cameraUpdate)
            }
            $0.mapView.minZoomLevel = 13
            $0.mapView.addCameraDelegate(delegate: self)
        }
        
        markerImg.do {
            $0.image = UIImage(named: "DIVIDEMarker")
        }
        
        searchTextField.do {
            $0.cornerRadius = 16
            $0.backgroundColor = .viewBackgroundGray
            $0.setPaddingFor(left: 15)
            $0.attributedPlaceholder = NSAttributedString(string: "도로명 주소 직접 입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray2])
            $0.textColor = .black
            $0.delegate = self
            $0.keyboardType  = .default
            $0.returnKeyType = .done
            $0.resignFirstResponder()
            
            $0.isHidden = true
        }
        
        titleAddressLabel.do {
            $0.text = "주소 요약"
            $0.textColor = .black
        }
        
        detailAddressLabel.do {
            $0.numberOfLines = 3
            $0.text = "여기가 어딘지 몰라몰라몰라여기가 어딘지 몰라몰라몰라여기가 어딘지 몰라몰라몰라여기가 어딘지 몰라몰라몰라여기가 어딘지 몰라몰라몰라여기가 어딘지 몰라몰라몰라여기가 어딘지 몰라몰라몰라여기가 어딘지 몰라몰라몰라여기가 어딘지 몰라몰라몰라여기가 어딘지 몰라몰라몰라여기가 어딘지 몰라몰라몰라"
            $0.textColor = .gray2
        }
    }
    
    internal func addView() {
        self.view.addSubviews([contentView, changeAddressButton])
        
        contentView.addSubviews([mapView, searchTextField, titleAddressLabel, detailAddressLabel])
        mapView.addSubviews([markerImg])
    }
    
    internal func setLayout() {
        changeAddressButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-23)
            $0.height.equalTo(50)
        }
        
        contentView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(navigationView.snp.bottom).offset(16)
            $0.bottom.equalTo(changeAddressButton.snp.top).offset(-22)
        }
        
        mapView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.top.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().offset(-18)
            $0.height.equalTo(351)
        }
        
        markerImg.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(27)
            $0.height.equalTo(40)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(mapView)
            $0.trailing.equalTo(mapView)
            $0.top.equalTo(mapView.snp.bottom).offset(21)
            $0.height.equalTo(33)
        }
        
        titleAddressLabel.snp.makeConstraints {
            $0.leading.equalTo(searchTextField)
            $0.trailing.equalTo(searchTextField)
            $0.height.equalTo(21)
            $0.top.equalTo(searchTextField.snp.bottom).offset(19)
        }
        
        detailAddressLabel.snp.makeConstraints {
            $0.leading.equalTo(titleAddressLabel)
            $0.trailing.equalTo(titleAddressLabel)
            $0.top.equalTo(titleAddressLabel.snp.bottom).offset(8)
        }
    }

    internal func addAction() {
        changeAddressButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            let latitude = self.mapView.mapView.cameraPosition.target.lat
            let longitude = self.mapView.mapView.cameraPosition.target.lng
            let userPostion = UserPosition(longitude: longitude, latitude: latitude)
            
            setUserPositon(userPosition: userPostion) {
                print("유저 위치 설정 완료 팝업 띄우기")
                self.presentAlert(title: "위치 정보 설정 완료") {_ in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }), for: .touchUpInside)
    }
    
    private func getCurrentLocation() -> NMGLatLng? {
        guard let currentLatitude = locationManager.location?.coordinate.latitude else { return nil }
        guard let currentLongitude = locationManager.location?.coordinate.longitude else { return nil }
        
        return NMGLatLng(lat: currentLatitude, lng: currentLongitude)
    }
    func setUserPositon(userPosition: UserPosition, completion : @escaping () -> Void ) {
        realProvider.request(.setUserPosition(position: userPosition)) { result in
            UserDefaultsManager.userPosition = userPosition
            print("=========================")
            print("     유저 위치 설정 결과")
            switch result {
            case let .success(reponse):
                completion()
                print(reponse)
            case let .failure(error):
                print(error.localizedDescription)
            }
            print("=========================")
        }
    }
}

extension ChangeDefaultAddressViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textfield: UITextField) {
        self.view.frame.origin.y -= 200
        self.view.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                textfield.resignFirstResponder()
            }.disposed(by: disposeBag)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.frame.origin.y += 200
    }
    
}

extension ChangeDefaultAddressViewController : NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        self.titleAddressLabel.text = "위치 검색중"
        self.detailAddressLabel.text = ""
    }
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let lat = mapView.cameraPosition.target.lat
        let lng = mapView.cameraPosition.target.lng
        
        GeocodingManager.reverseGeocoding(lat: lat, lng: lng) { location in
            DispatchQueue.main.async {
                self.titleAddressLabel.text = location
            }
        }
    }
}

