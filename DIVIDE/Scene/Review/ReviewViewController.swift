//
//  ReviewViewController.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/12/22.
//

import UIKit
import RxSwift
import RxCocoa

import SnapKit
import Then

final class ReviewViewController: UIViewController {
    
    private var disposeBag              = DisposeBag()
    private var viewModel : ReviewBusinessLogic?
    private let dummyUserPosition       = UserPosition(longitude: 127.030767490, latitude: 37.49015482509)

    //상단
    private let topTitleView            = UIView()
    private let reviewTitleImg          = UIImageView()
    private let reviewSearchBtn         = UIButton()
    
    
    //tableView
    private let reviewTableView         = UITableView()
    private var allReviewDataFromServer = [ReviewData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setAttribute()
        addView()
        setLayout()
        
        reviewTableView.register(ReviewRecommendTableViewCell.self, forCellReuseIdentifier: ReviewRecommendTableViewCell.className)
        reviewTableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.className)
        bindTableView()
        
    }
    
    private func setUp() {
        self.viewModel = ReviewViewModel()
    }
    private func setAttribute() {
        self.view.backgroundColor = .viewBackgroundGray
        topTitleView.do {
            $0.backgroundColor = .white
            $0.layer.addBorder([.bottom], color: .borderGray, width: 1)
            $0.layer.addShadow(location: .bottom)
        }
        reviewTitleImg.do {
            $0.image = UIImage(named: "ReviewTitle.png")
        }
        reviewSearchBtn.do {
            $0.setImage(UIImage(named: "Search.png"), for: .normal)
        }
        
        
        reviewTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .viewBackgroundGray
            $0.separatorStyle = .none
        }

    }
    private func addView() {
        self.view.addSubview(topTitleView)
        topTitleView.addSubviews([reviewTitleImg, reviewSearchBtn])
        
        self.view.addSubview(reviewTableView)
    }
    private func setLayout() {
        
        topTitleView.snp.makeConstraints {
            $0.height.equalTo(113)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        reviewTitleImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(15)
            $0.height.equalTo(28.7)
            $0.width.equalTo(127.37)
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
            $0.top.equalTo(topTitleView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
 
    }
    private func bindTableView(){
        reviewTableView.rx.setDelegate(self).disposed(by: disposeBag)
        // 테스트 하려면 dummy로 하면 됨 강남구 역삼동 주변으로 조회 됨.
        self.viewModel?.requestAroundReviews(param: UserDefaultsManager.userPosition ?? dummyUserPosition)
            .asObservable()
            .bind(to: reviewTableView.rx.items(cellIdentifier: ReviewTableViewCell.className, cellType: ReviewTableViewCell.self)) { [weak self] (row, item, cell) in
                guard let self = self else { return }
                self.allReviewDataFromServer.append(item)
                cell.setData(reviewData: item)
                GeocodingManager.reverseGeocoding(lat: item.review.latitude, lng: item.review.longitude) { location in
                    cell.setLocation(location: location)
                }
            }.disposed(by: disposeBag)
    }

}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allReviewDataFromServer.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.className, for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = ReviewDetailViewController()
        destinationVC.setReviewId(reviewId : allReviewDataFromServer[indexPath.row].review.reviewId)
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
}
