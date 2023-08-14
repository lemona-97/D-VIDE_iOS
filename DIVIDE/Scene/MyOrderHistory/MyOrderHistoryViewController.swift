//
//  MyOrderHistoryViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/03.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

final class MyOrderHistoryViewController: UIViewController {
    private var disposeBag = DisposeBag()
    
    private var viewModel : MyOrderBusinessLogic?
    
    //Property
    private let topTitleView = UIView()
    private let closeButton = UIButton()
    private let topTitleLabel = MainLabel(type: .title)
    
    private let tableView = UITableView()
    private var allDataFromServer = [OrderHistory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setAttribute()
        addView()
        setLayout()
        
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.className)
        bindToViewModel()
        addAction()
    }
    
    private func setUp() {
        self.viewModel = MyOrderHistoryViewModel()
    }
    
    private func setAttribute() {
        view.backgroundColor = .viewBackgroundGray

        topTitleView.do {
            $0.backgroundColor = .white
            $0.layer.addBorder([.bottom], color: .borderGray, width: 1)
            $0.layer.addShadow(location: .bottom)
        }
        
        topTitleLabel.do {
            $0.text = "주문내역"
        }
        
        closeButton.do {
            $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            $0.tintColor = .gray4
        }
        tableView.do{
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle  = .none
        }
    }
    
    private func addView() {
        self.view.addSubview(topTitleView)
        topTitleView.addSubviews([closeButton, topTitleLabel])
        self.view.addSubview(tableView)
    }
    
    private func setLayout() {
        topTitleView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(100)
        }
        closeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview().offset(15)
            $0.height.equalTo(25)
            $0.width.equalTo(15)
        }
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(10)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(topTitleView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func bindToViewModel() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.viewModel?.requestMyOrderHistory()
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "OrderTableViewCell", cellType: OrderTableViewCell.self)) {
                (row, item, cell) in
                self.allDataFromServer.append(item)
                cell.setHistoryData(data: item)
                
                GeocodingManager.reverseGeocoding(lat: item.post.latitude, lng: item.post.longitude) { location in
                    DispatchQueue.main.async {
                        cell.setLocation(location: location)
                    }
                }
            }.disposed(by: disposeBag)
    }
    private func addAction() {
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
    }
}

extension MyOrderHistoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as? OrderTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! OrderTableViewCell
        let destination = PostReviewViewController()
        destination.setData(postId: currentCell.getPostId(), storeName: currentCell.getStoreName())
        self.navigationController?.pushViewController(destination, animated: true)
    }
}
