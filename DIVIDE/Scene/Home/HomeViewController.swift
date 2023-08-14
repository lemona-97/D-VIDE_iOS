//
//  ViewController.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/06/28.
//

import UIKit
import Then
import SnapKit
import Moya
import RxCocoa
import RxSwift
import CoreLocation

final class HomeViewController: UIViewController, CLLocationManagerDelegate {
    private var disposeBag = DisposeBag()
    
    private var viewModel : HomeViewModelBusinessLogic?
    
    private let dateFormatter = DateFormatter()
    
    
    // 나중에 사용자의 현재 위치 받아오기
    private let dummyUserPosition = UserPosition(longitude: 127.030767490, latitude: 37.49015482509)
    
    private var locationManager = CLLocationManager()
    private var userPosition : UserPosition? = nil
    private let topTitleView = UIView()
    private let searchBtn = UIButton()
    private let topMenuCollectionView = UICollectionView(frame: .zero, collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
    
    
    private let backgroundImage = UIImageView()
    
    private let tableView = UITableView()
    private let DVIDEBtn = UIButton()
    private var allDataFromServer = [Datum]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenuCollectionView.register(HomeTopMenuCollectionViewCell.self, forCellWithReuseIdentifier: HomeTopMenuCollectionViewCell.className)
        topMenuCollectionView.delegate = self
        topMenuCollectionView.dataSource = self
        
        setAttribute()
        addView()
        setLayout()
        setUp()
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.className)
        
        DVIDEBtn.addTarget(self, action: #selector(self.tapDIVIDEBtn), for: .touchUpInside)
        
        
        bindToViewModel()

    }
    
    
    private func setUp() {
        let viewModel = HomeViewModel()
        self.viewModel = viewModel
        if let userPosition = (UserDefaultsManager.userPosition) {
            self.userPosition = userPosition
        } else {
            print("유저 위치 확인 안됨.")
            self.userPosition = dummyUserPosition
        }
        //        self.userPosition = UserPosition(longitude: (locationManager.location?.coordinate.longitude), latitude: (locationManager.location?.coordinate.latitude))
        
    }
    private func setAttribute() {
        view.backgroundColor = .viewBackgroundGray
        
        topTitleView.do {
            $0.backgroundColor = .white
            $0.layer.addBorder([.bottom], color: .borderGray, width: 1)
            $0.layer.addShadow(location: .bottom)
        }
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
            topMenuCollectionView.collectionViewLayout = flowLayout
        }
        
        tableView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
        }
        
        DVIDEBtn.do {
            $0.setImage(UIImage(named: "WritePost.png"), for: .normal)
        }
        
        dateFormatter.do {
            $0.dateFormat = "H:mm"
        }
    }
    private func addView() {
        view.addSubview(topTitleView)
        view.addSubview(searchBtn)
        view.addSubview(topMenuCollectionView)
        
        view.addSubview(backgroundImage)
        view.addSubview(tableView)
        view.addSubview(DVIDEBtn)
    }
    private func setLayout() {
        topTitleView.snp.makeConstraints {
            $0.height.equalTo(113)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.snp.top)
        }
        searchBtn.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
            $0.top.equalToSuperview().offset(48)
            $0.trailing.equalToSuperview().offset(-40)
        }
        topMenuCollectionView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(topTitleView)
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
    
    private func bindToViewModel(){
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel?.requestAroundPosts(param: self.userPosition ?? dummyUserPosition)
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: OrderTableViewCell.className, cellType: OrderTableViewCell.self)) { (row, item, cell) in
                
                self.allDataFromServer.append(item)
                cell.setData(data: item)
                
                GeocodingManager.reverseGeocoding(lat: item.post.latitude, lng: item.post.longitude, completion: { location in
                    DispatchQueue.main.async {
                        cell.setLocation(location: location)
                    }
                    
                })
                
            }.disposed(by: disposeBag)
    }
    
    @objc func tapDIVIDEBtn() {
        let view = PostRecruitingViewController()
        self.navigationController?.pushViewController(view, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //diffable 컬렉션뷰 + modern collectionView 적용해보기?
        
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
            .bind(to: tableView.rx.items(cellIdentifier: OrderTableViewCell.className, cellType: OrderTableViewCell.self)) { (row, item, cell) in
                self.allDataFromServer.append(item)
                cell.setData(data: item)
                DispatchQueue.global().async {
                    GeocodingManager.reverseGeocoding(lat: item.post.latitude, lng: item.post.longitude, completion: { location in
                        cell.setLocation(location: location)
                    })
                }
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
        
        let destinationVC = PostDetailViewController()
        destinationVC.setPostId(postId: allDataFromServer[indexPath.row].post.id)
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
        
    }
    
    
}

