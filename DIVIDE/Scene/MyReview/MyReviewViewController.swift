//
//  MyReviewViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/09.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

final class MyReviewViewController: UIViewController {

    private var viewModel : MyReviewBusinessLogic?
    private var disposeBag = DisposeBag()
    
    private let backButton = UIButton()
    private let topTitleLabel = MainLabel(type: .title)
    
    private let reviewTableView = UITableView()
    private var myReviewData = [ReviewData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setAttribute()
        addView()
        setLayout()
        
        bindTableView()
        addAction()
    }
  
    
    private func setUp() {
        viewModel = MyReviewViewModel()
    }
    
    private func setAttribute() {
        self.view.backgroundColor = .viewBackgroundGray
        backButton.do {
            $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            $0.setTitleColor(.gray3, for: .normal)
            $0.tintColor = .gray3
        }
        
        topTitleLabel.do {
            $0.text = "내가 쓴 리뷰"
        }
        
        reviewTableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.className)
        reviewTableView.do {
            $0.separatorStyle = .none
            $0.backgroundColor = .viewBackgroundGray
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private func addView() {
        self.view.addSubviews([backButton, topTitleLabel, reviewTableView])
    }
    
    private func setLayout() {
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(50)
            $0.height.equalTo(40)
            $0.width.equalTo(25)
        }
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
        }
        reviewTableView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(backButton.snp.bottom).offset(20)
        }
    }

    private func bindTableView() {
        reviewTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.viewModel?.requestMyReview(first: 0)
            .asObservable()
            .bind(to: reviewTableView.rx.items(cellIdentifier: ReviewTableViewCell.className, cellType: ReviewTableViewCell.self)) { [weak self]  (row, item, cell) in
                guard let self = self else { return }
                self.myReviewData.append(item)
                cell.setData(reviewData: item)
                GeocodingManager.reverseGeocoding(lat: item.review.latitude, lng: item.review.longitude) { location in
                    cell.setLocation(location: location)
                }
            }.disposed(by: disposeBag)
    }

    
    private func addAction() {
        backButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
    }
}

extension MyReviewViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = ReviewDetailViewController()
        destinationVC.setReviewId(reviewId : myReviewData[indexPath.row].review.reviewId)
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
}
