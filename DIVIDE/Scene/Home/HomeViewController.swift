//
//  ViewController.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/06/28.
//

import Moya
import RxCocoa
import RxSwift
import CoreLocation

final class HomeViewController: DVIDEViewController1, ViewControllerFoundation, CLLocationManagerDelegate {
   
    private var disposeBag = DisposeBag()
    
    private var viewModel : HomeViewModelBusinessLogic?
    
    private let dateFormatter = DateFormatter()
    
    
    // 나중에 사용자의 현재 위치 받아오기
    private let dummyUserPosition = UserPosition(longitude: 126.98714734599184, latitude: 37.56055250541176)
    
    private var locationManager = CLLocationManager()
    private var userPosition : UserPosition? = nil
    private let searchBtn = UIButton()
    private let topMenuCollectionView = UICollectionView(frame: .zero, collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
    
    
    private let backgroundImage = UIImageView()
    
    private let tableView = UITableView()
    private let DVIDEBtn = UIButton()
    private var allDataFromServer = [Datum]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        addView()
        setLayout()
        setUp()
        addAction()
        bindToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    internal func setUp() {
        let viewModel = HomeViewModel()
        self.viewModel = viewModel
        if let userPosition = (UserDefaultsManager.userPosition) {
            let lng = userPosition.longitude
            let lat = userPosition.latitude
            if lng < 124 || lng > 132 || lat < 33 || lat > 43 {
                self.userPosition = dummyUserPosition

            }else {
                self.userPosition = userPosition

            }
        } else {
            print("유저 위치 확인 안됨.")
            self.userPosition = dummyUserPosition
        }
        
    }
    internal func setAttribute() {
        
        searchBtn.do {
            $0.setImage(#imageLiteral(resourceName: "Search.png"), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFill
        }
        backgroundImage.do {
            $0.image = UIImage(named: "HomeBackgroundImage")
            $0.isHidden = true
        }
        topMenuCollectionView.do {
            let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            flowLayout.estimatedItemSize = CGSize(width: 47, height: 26)
            flowLayout.scrollDirection = .horizontal
            $0.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
            $0.backgroundColor = .white
            $0.showsHorizontalScrollIndicator = false
            $0.collectionViewLayout = flowLayout
            
            $0.register(HomeTopMenuCollectionViewCell.self, forCellWithReuseIdentifier: HomeTopMenuCollectionViewCell.className)
            $0.delegate = self
            $0.dataSource = self
            
        }
        
        tableView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.className)
        }
        
        DVIDEBtn.do {
            $0.setImage(UIImage(named: "WritePost.png"), for: .normal)
        }
        
        dateFormatter.do {
            $0.dateFormat = "H:mm"
        }
    }
    internal func addView() {
        view.addSubview(searchBtn)
        view.addSubview(topMenuCollectionView)
        
        view.addSubview(backgroundImage)
        view.addSubview(tableView)
        view.addSubview(DVIDEBtn)
    }
    internal func setLayout() {
//        searchBtn.snp.makeConstraints {
//            $0.width.equalTo(20)
//            $0.height.equalTo(20)
//            $0.top.equalToSuperview().offset(48)
//            $0.trailing.equalToSuperview().offset(-40)
//        }
        topMenuCollectionView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationView)
        }
        tableView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(123)
            $0.bottom.equalToSuperview().offset(-90)
        }
        backgroundImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(150)
        }
        DVIDEBtn.snp.makeConstraints {
            $0.width.equalTo(115)
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().offset(26)
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
    
    internal func addAction() {
        DVIDEBtn.addAction(UIAction(handler: { _ in
            let destination = PostRecruitingViewController()
            self.navigationController?.pushViewController(destination, animated: true)
        }), for: .touchUpInside)
    }
    
    private func bindToViewModel(){
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel?.requestAroundPosts(param: self.userPosition ?? dummyUserPosition)
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: OrderTableViewCell.className, cellType: OrderTableViewCell.self)) { [weak self] (row, item, cell) in
                guard let self = self else { return }
                self.allDataFromServer.append(item)
                cell.setData(data: item)
                GeocodingManager.reverseGeocoding(lat: item.post.latitude, lng: item.post.longitude, completion: { location in
                    DispatchQueue.main.async {
                        cell.setLocation(location: location)
                    }
                    
                })
                
            }.disposed(by: disposeBag)
    }
    

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.allCases.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTopMenuCollectionViewCell.className, for: indexPath) as! HomeTopMenuCollectionViewCell
        if indexPath.item == 0 {
            cell.menuLabel.text = " " + "전체" + " "
            return cell
        }
        cell.menuLabel.text = " " + categories.allCases[indexPath.row - 1].category + " "
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: -diffable 컬렉션뷰 + modern collectionView 적용해보기?
        
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        allDataFromServer.removeAll()
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        if indexPath.row == 0 {
            bindToViewModel()
            return
        }
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        let selectedCatagory = categories.allCases[indexPath.item - 1].categoryName
        viewModel?.requestAroundPostsWithCategory(param: self.userPosition ?? dummyUserPosition, category: selectedCatagory)
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: OrderTableViewCell.className, cellType: OrderTableViewCell.self)) {[weak self] (row, item, cell) in
                guard let self = self else { return }
                self.allDataFromServer.append(item)
                cell.setData(data: item)
                GeocodingManager.reverseGeocoding(lat: item.post.latitude, lng: item.post.longitude, completion: { location in
                        cell.setLocation(location: location)
                })
            }.disposed(by: disposeBag)
    }
}

//테이블 - post
extension HomeViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.className, for: indexPath) as? OrderTableViewCell else { return UITableViewCell() }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? OrderTableViewCell
        if cell?.userId == nil {
            let destination = PopupViewController()
            destination.dismissListener = { }
            destination.modalPresentationStyle = .overFullScreen
            destination.setPopupMessage(message: "탈퇴한 사용자의 글 입니다.", popupType: .ALERT)
            self.navigationController?.present(destination, animated: false)
        } else {
            guard let remaintime = cell?.remainEpochTime else { return }
            if remaintime > Int(Date().timeIntervalSince1970) {
                let destinationVC = PostDetailViewController()
                destinationVC.setPostId(postId: allDataFromServer[indexPath.row].post.id)
                
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
        
    }
}


