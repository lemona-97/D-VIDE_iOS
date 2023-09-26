//
//  OtherProfileViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/17.
//

import RxSwift
import RxCocoa
import RxGesture

final class OtherProfileViewController: UIViewController, ViewControllerFoundation {

    var userId : Int?
    
    private let profileBox                  = UIView()
    
    private let leftBox                     = UIView()
    private let profileImageView            = UIImageView()
    private let profileImageIndicator       = UIActivityIndicatorView()
    private let profileNickname             = MainLabel(type: .Point3)
    private let profileBadge                = MainLabel(type: .orange)
    
    private let rightBox                    = UIView()
    private let followingCountLabel         = MainLabel(type: .Point5)
    private let followingLabel              = MainLabel(type: .small3)
    private let followingTouchBox           = UIView()
    private let rightBoxDivider             = UIView()
    private let followerCountLabel          = MainLabel(type: .Point5)
    private let followerLabel               = MainLabel(type: .small3)
    private let followerTouchBox            = UIView()
    private let followButton                = MainButton(type: .followAction)
    
    private let feedLabel                   = MainLabel(type: .Basics4)
    private let feedTableView               = UITableView()
    private var otherReviewData  : [Review] = []
    
    private var viewModel : OtherProfileBusinessLogic?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        addView()
        setLayout()
        setUp()
        requestOtherProfile()
        
        addAction()
    }
    
    internal func setAttribute() {
        self.view.backgroundColor = .gray0
        
        leftBox.do {
            $0.backgroundColor = .white
            $0.roundCorner(corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 41)
            $0.roundCorner(corners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner], cornerRadius: 14)
            $0.clipsToBounds = false
        }
        
        rightBox.do {
            $0.backgroundColor = .white
            $0.cornerRadius = 14
        }
        profileImageView.do {
            $0.cornerRadius = 41
            $0.contentMode = .scaleAspectFit
            $0.borderWidth = 2
            $0.borderColor = .lightOrange
            $0.backgroundColor = .white
        }
        
        profileImageIndicator.do {
            $0.color = .lightOrange
        }
        
        profileNickname.do {
            $0.textAlignment = .left
            $0.textColor = .black
            $0.text = "닉네임 불러오는중"
        }
        profileBadge.do {
            $0.textAlignment = .left
            $0.text = "뱃지 불러오는중"
        }
        
        followingCountLabel.do {
            $0.textAlignment = .center
            $0.textColor = .black
            $0.text = "0"
        }
        
        followingLabel.do {
            $0.textAlignment = .center
            $0.text = "팔로잉"
        }
        
        rightBoxDivider.do {
            $0.backgroundColor = .gray1
        }
        
        followerCountLabel.do {
            $0.textAlignment = .center
            $0.textColor = .black
            $0.text = "0"
        }
        
        followerLabel.do {
            $0.textAlignment = .center
            $0.text = "팔로워"
        }
        
        feedTableView.do {
            $0.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.className)
        }
        
        followButton.do {
            $0.setTitle("팔로우", for: .normal)
            $0.setTitle("팔로우 취소", for: .selected)
            $0.setTitleColor(.white, for: .selected)
            $0.setBackgroundColor(.mainOrange1, for: .selected)
        }
        
        feedLabel.do {
            $0.textColor = .black
            $0.text = "• OO님의 피드"
        }
        
        feedTableView.do {
            $0.separatorStyle = .none
            $0.backgroundColor = .gray0
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    internal func addView() {
        self.view.addSubviews([profileBox, followButton, feedLabel, feedTableView])
        profileBox.addSubviews([leftBox, rightBox])
        leftBox.addSubviews([profileImageView, profileNickname, profileBadge])
        rightBox.addSubviews([followingCountLabel, followingLabel, rightBoxDivider, followerCountLabel, followerLabel, followingTouchBox, followerTouchBox])
    }
    
    internal func setLayout() {
        profileBox.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalTo(profileImageView.snp.centerX)
            $0.trailing.equalToSuperview().offset(-22)
            $0.height.equalTo(82)
        }
        
        leftBox.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(profileBox.snp.width).multipliedBy(0.58)
        }
        
        rightBox.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
            $0.leading.equalTo(leftBox.snp.trailing).offset(7)
            $0.height.equalTo(56)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(self.view).offset(22)
            $0.width.equalTo(82)
        }
        
        profileNickname.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(11)
            $0.top.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        profileBadge.snp.makeConstraints {
            $0.leading.equalTo(profileNickname)
            $0.top.equalTo(profileNickname.snp.bottom)
            $0.height.equalTo(12)
            $0.trailing.equalToSuperview()
        }
        
        rightBoxDivider.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(1)
            $0.top.equalToSuperview().offset(17)
            $0.bottom.equalToSuperview().offset(-17)
        }
        
        followingCountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(rightBoxDivider.snp.leading)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(25)
        }
        
        followingLabel.snp.makeConstraints {
            $0.centerX.equalTo(followingCountLabel)
            $0.top.equalTo(followingCountLabel.snp.bottom)
            $0.height.equalTo(14)
        }
        
        followerCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(rightBoxDivider.snp.trailing)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(25)
        }
        
       
        followerLabel.snp.makeConstraints {
            $0.centerX.equalTo(followerCountLabel)
            $0.top.equalTo(followerCountLabel.snp.bottom)
            $0.height.equalTo(14)
        }
        
        followingTouchBox.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(rightBox)
            $0.trailing.equalTo(rightBoxDivider.snp.leading)
        }
        
        followerTouchBox.snp.makeConstraints {
            $0.top.trailing.bottom.equalTo(rightBox)
            $0.leading.equalTo(rightBoxDivider.snp.trailing)
        }
        
        followButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(rightBox)
            $0.top.equalTo(rightBox.snp.bottom).offset(9)
            $0.height.equalTo(20)
        }
        
        feedLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView).offset(13)
            $0.top.equalTo(profileBox.snp.bottom).offset(20)
            $0.height.equalTo(14)
            $0.trailing.equalTo(rightBox)
        }
        
        feedTableView.snp.makeConstraints {
            $0.top.equalTo(feedLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
    
    internal func setUp() {
        self.viewModel = OtherProfileViewModel()
    }
    
    private func requestOtherProfile() {
        guard let userId = self.userId else { return }
        self.viewModel?.requestOtherProfile(userId: userId, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                
                self.profileImageView.load(url: result.profileImgUrl!) {
                    self.profileImageIndicator.stopAnimating()
                }
                self.profileNickname.text = result.nickname!
                self.profileBadge.text  = result.badge?.name
                self.followingCountLabel.text = String(result.followerCount!)
                self.followerCountLabel.text = String(result.followingCount!)
                self.feedLabel.text = "• " + String(result.nickname!) + "님의 피드"
                if result.followed! {
                    self.followButton.isSelected = true
                } else {
                    self.followButton.isSelected = false
                }
                
            case .failure(let err):
                print(err)
            }
            bindToViewModel()
        })
    }
    
    private func bindToViewModel() {
        feedTableView.rx.setDelegate(self).disposed(by: disposeBag)
        guard let userId = self.userId else { return }
        self.viewModel?.requestOtherReview(userId : userId, first : 0)
            .asObservable()
            .bind(to : feedTableView.rx.items(cellIdentifier: ReviewTableViewCell.className, cellType: ReviewTableViewCell.self)) { [weak self] (row, item, cell) in
                guard let self = self else { return }
                self.otherReviewData.append(item)
                cell.setData(review: item, profileImage: self.profileImageView.image!, nickname: self.profileNickname.text!)
                GeocodingManager.reverseGeocoding(lat: item.latitude, lng: item.longitude) { location in
                   cell.setLocation(location: location)
                }
            }.disposed(by: disposeBag)
    }
    
    internal func addAction() {
        followButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            guard let userId = self.userId else { return }
            
            if self.followButton.isSelected {
                viewModel?.unfollowUser(userId: userId, completion: { result in
                    switch result {
                    case .success(let response):
                        
                        if let _ = response.result  {
                            print(" 유저 \(userId) 언팔로우 성공")
                            var before = Int(self.followerCountLabel.text!)
                            var after = before! - 1
                            self.followerCountLabel.text = String(after)
                        } else {
                            print(" 유저 \(userId) 언팔로우 실패")
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                })
                
            } else {
                viewModel?.followUser(userId: userId, completion: { result in
                    switch result {
                    case .success(let response):
                        if let result = response.followId {
                            print(" 유저 \(result) 팔로우")
                            var before = Int(self.followerCountLabel.text!)
                            var after = before! + 1
                            self.followerCountLabel.text = String(after)
                            
                        } else {
                            print(" 유저 \(result) 팔로우 실패")
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                })
                
            }
            self.followButton.isSelected.toggle()
        }), for: .touchUpInside)
        
        followingTouchBox.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                print("팔로잉 목록 보기!")
                guard let self = self else { return }
                let destination = FollowViewController()
                destination.type = .FOLLOWING
                destination.userId = self.userId
                destination.isOther = true
                print(String(describing: self.navigationController))
                print(String(describing: self.parent))
                
                let navCon = UINavigationController(rootViewController: destination)
                navCon.modalPresentationStyle = .fullScreen
                navCon.modalTransitionStyle = .flipHorizontal
                self.present(navCon, animated: true)
                
                
                self.parent?.navigationController?.pushViewController(destination, animated: true)
            }.disposed(by: disposeBag)
        
        followerTouchBox.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                print("팔로우 목록 보기!")
                guard let self = self else { return }
                let destination = FollowViewController()
                destination.type = .FOLLOWER
                destination.userId = self.userId
                destination.isOther = true
                self.navigationController?.pushViewController(destination, animated: true)
            }.disposed(by: disposeBag)
        
    }
}

extension OtherProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        otherReviewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.className, for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        161
    }
}
