//
//  FollowViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/08.
//

import UIKit
import RxSwift
import RxCocoa

import SnapKit
import Then

final class FollowViewController: UIViewController {
    private let navigationView                  = UIView()
    private let navigationLabel                 = MainLabel(type: .hopang)
    private let backButton                      = UIButton()

    private let followCollectionView       = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var type : FollowType?
    var isOther = false
    var userId : Int?
    private var allDataOfFollowInfo  : [FollowInfo] = []
    private var allDataOfOtherFollowInfo : [OtherFollowModel] = []
    private var viewModel : FollowBusinessLogic?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setAttribute()
        addView()
        setLayout()
        addAction()
        bindFollow()
    }
    
    private func setUp() {
        viewModel = FollowViewModel()
    }
    
    private func setAttribute() {
        self.view.backgroundColor = .white
        navigationView.do {
            $0.backgroundColor = .white
            $0.layer.addBorder([.bottom], color: .borderGray, width: 1)
            $0.layer.addShadow(location: .bottom)
        }
        if type == .FOLLOWER {
            navigationLabel.do {
                $0.text = "팔로워"
            }
        } else {
            navigationLabel.do {
                $0.text = "팔로잉"
            }
        }
        
        backButton.do {
            $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            $0.tintColor = .gray
        }
        
        followCollectionView.do {
            let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            $0.collectionViewLayout = flowLayout
            $0.showsVerticalScrollIndicator = false
            $0.register(FollowCollectionViewCell.self, forCellWithReuseIdentifier: FollowCollectionViewCell.className)
            $0.backgroundColor = .clear
            $0.contentSize = flowLayout.estimatedItemSize
        }
    }
    
    private func addView() {
        view.addSubview(navigationView)
        
        navigationView.addSubview(navigationLabel)
        navigationView.addSubview(backButton)
        
        view.addSubview(followCollectionView)
    }
    
    private func setLayout() {
        navigationView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        navigationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(navigationView.snp.bottom).offset(-20)
        }
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalTo(navigationLabel)
            $0.width.height.equalTo(30)
        }
        
        followCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().offset(-19)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func addAction() {
        backButton.addAction(UIAction(handler: {[weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
        }), for: .touchUpInside)
    }
    
    private func bindFollow() {
        
        guard let type = self.type else { return }
        followCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        if isOther {
            if let userId = self.userId {
                self.viewModel?.requestOtherFollowList(relation: type, first: 0, userId: userId)
                    .asObservable()
                    .bind(to: followCollectionView.rx.items(cellIdentifier: FollowCollectionViewCell.className, cellType: FollowCollectionViewCell.self)) { (row, item, cell) in
                        self.allDataOfOtherFollowInfo.append(item)
                        
                        cell.setData(type: type, info: item)
                    }.disposed(by: disposeBag)


            }
        } else {
            self.viewModel?.requestFollowList(type: type, first: nil)
                .asObservable()
                .bind(to: followCollectionView.rx.items(cellIdentifier: FollowCollectionViewCell.className, cellType: FollowCollectionViewCell.self)) { (row, item, cell) in
                    self.allDataOfFollowInfo.append(item)
                    
                    cell.setData(type: type, info: item)
                }.disposed(by: disposeBag)
        }
        
    }
    
}

extension FollowViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allDataOfFollowInfo.count + allDataOfOtherFollowInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowCollectionViewCell.className, for: indexPath) as! FollowCollectionViewCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.followCollectionView.bounds.width, height: 50)
    }
}
