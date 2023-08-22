//
//  MyOrderHistoryViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/03.
//

import RxSwift
import RxCocoa

final class MyOrderHistoryViewController: DVIDEViewController2, ViewControllerFoundation {
    private var disposeBag = DisposeBag()
    
    private var viewModel : MyOrderBusinessLogic?
    
    private let tableView = UITableView()
    private var allDataFromServer = [OrderHistory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setAttribute()
        addView()
        setLayout()
        bindToViewModel()
        addAction()
    }
    
    internal func setUp() {
        self.viewModel = MyOrderHistoryViewModel()
    }
    
    internal func setAttribute() {
        view.backgroundColor = .viewBackgroundGray
        
        navigationLabel.do {
            $0.text = "주문내역"
        }
        tableView.do{
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle  = .none
            $0.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.className)
        }
    }
    
    internal func addView() {
        self.view.addSubview(tableView)
    }
    
    internal func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(5)
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
    internal func addAction() {
        
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
