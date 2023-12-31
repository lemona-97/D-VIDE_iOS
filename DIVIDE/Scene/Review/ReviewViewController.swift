//
//  ReviewViewController.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/12/22.
//

import RxSwift
import RxCocoa

final class ReviewViewController: DVIDEViewController1, ViewControllerFoundation {
    private let navigationLabel         = MainLabel(type: .hopang)
    
    private var disposeBag              = DisposeBag()
    private var viewModel               : ReviewBusinessLogic?
    private let dummyUserPosition       = UserPosition(longitude: 126.98714734599184, latitude: 37.56055250541176)
    
    //상단
    private let reviewSearchBtn         = UIButton()
    
    
    //tableView
    private let reviewTableView         = UITableView()
    private var allReviewDataFromServer = [ReviewData]()
    private var isLast = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setAttribute()
        addView()
        setLayout()
        
        reviewTableView.register(ReviewRecommendTableViewCell.self, forCellReuseIdentifier: ReviewRecommendTableViewCell.className)
        reviewTableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.className)
        fetchAroundReviews()
        
    }
    
    internal func setUp() {
        self.viewModel = ReviewViewModel()
    }
    internal func setAttribute() {
        navigationLabel.do {
            $0.text = "D/VIDE 리뷰"
            $0.textAlignment = .center
        }
        
        reviewSearchBtn.do {
            $0.setImage(UIImage(named: "Search.png"), for: .normal)
            $0.isHidden = true
        }
        
        
        reviewTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .viewBackgroundGray
            $0.separatorStyle = .none
            $0.isUserInteractionEnabled = true
        }
        
    }
    internal func addView() {
        self.view.addSubview(navigationView)
        navigationView.addSubviews([navigationLabel, reviewSearchBtn])
        
        self.view.addSubview(reviewTableView)
    }
    internal func setLayout() {
        navigationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(navigationView.snp.bottom).offset(-20)
        }
        
        reviewSearchBtn.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(20)
            $0.top.equalToSuperview().offset(65)
            $0.trailing.equalToSuperview().offset(-30)
        }
        
        reviewTableView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
        
    }
    private func fetchAroundReviews(){
        
        // 테스트 하려면 dummy로 하면 됨 강남구 역삼동 주변으로 조회 됨.
        self.viewModel?.requestAroundReviews(param: UserDefaultsManager.userPosition ?? dummyUserPosition, skip: 0)
            .asObservable()
            .debug()
            .subscribe(onNext: { data in
                if data.count != 10 {
                    self.isLast = true
                }
                self.allReviewDataFromServer.append(contentsOf: data)
            }, onError: { err in
                print(err)
            }, onCompleted: {
                print("completed.")
                self.reviewTableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    internal func addAction() {
        
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allReviewDataFromServer.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.className, for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        if allReviewDataFromServer.count > 0 {
            let data = allReviewDataFromServer[indexPath.row]
            
            cell.setData(reviewData: data)
            cell.likeLisenter = { [weak self] in
                guard let self = self else { return }
                if cell.likeButton.isSelected {
                    cell.likeButton.isSelected.toggle()
                    self.viewModel?.requestReviewUnLike(reviewId: data.review.reviewId,
                                                        completion: { result in
                        switch result {
                        case .success(let response):
                            print("취소된 리뷰 ID : \(response.reviewId)")
                            cell.reviewLikeCount.text = String(Int(cell.reviewLikeCount.text ?? "0")! - 1)
                        case .failure(let err):
                            print(err)
                        }
                        
                    }) } else {
                        cell.likeButton.isSelected.toggle()
                        self.viewModel?.requestReviewLike(reviewId: data.review.reviewId, completion: { result in
                            switch result {
                            case .success(let response):
                                print("리뷰 좋아요 ID : \(response.reviewLikeId)")
                                cell.reviewLikeCount.text = String(Int(cell.reviewLikeCount.text ?? "0")! + 1)
                            case .failure(let err):
                                print(err)
                            }
                            
                        })
                    }
                
            }
            cell.detailLisenter = { [weak self] in
                let destinationVC = ReviewDetailViewController()
                destinationVC.setReviewId(reviewId : (data.review.reviewId))
                
                self?.navigationController?.pushViewController(destinationVC, animated: true)
            }
            
            GeocodingManager.reverseGeocoding(lat: data.review.latitude,
                                              lng: data.review.longitude) { location in
                cell.setLocation(location: location)
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == allReviewDataFromServer.count - 1 && !isLast && (allReviewDataFromServer.count > 0) {
            let skip = (allReviewDataFromServer.count / 10)
            
            
            viewModel?.requestAroundReviews(param: UserDefaultsManager.userPosition ?? dummyUserPosition, skip: skip)
                    .asObservable()
                    .subscribe(onNext: { [weak self] datums in
                        if datums.count != 10 {
                            self?.isLast = true
                        }
                        self?.allReviewDataFromServer.append(contentsOf: datums)
                    }, onError: { err in
                        print(err)
                    }, onCompleted: {
                        self.reviewTableView.reloadData()
                    })
                    .disposed(by: disposeBag)
            
            
        }
    }
}
