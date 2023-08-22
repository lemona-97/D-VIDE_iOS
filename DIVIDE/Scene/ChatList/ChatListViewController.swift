//
//  ChatListViewController.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/08/05.
//

import RxSwift
import RxCocoa
import FirebaseAuth
import Firebase

final class ChatListViewController: DVIDEViewController1, ViewControllerFoundation {
    
    private let navigationLabel         = MainLabel(type: .hopang)
    
    private var channels                = [Channel]()
    private var disposeBag              = DisposeBag()
    //    private var viewModel               =
    
    lazy var   currentUser             = Auth.auth().currentUser!
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Channels"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        channelStream.removeListener()
    }
    private let channelTableView         = UITableView()
    private let channelStream            = ChannelFirestoreStream()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        setAttribute()
        addView()
        setLayout()
        
        setupListener()
    }
    
    // 채팅 리스트 불러와야함
    internal func setUp() {
        let dummy = Channel(id: MESSEGING_ID, name: "우섭")
        let dummy2 = Channel(id: "임우섭", name: "임우섭")
        channels.append(dummy)
        channels.append(dummy2)
    }
    
    internal func setAttribute() {
        navigationLabel.do {
            $0.text = "D/VIDE 채팅"
            $0.textAlignment = .center
        }
        
        channelTableView.do {
            $0.register(ChatListTableViewCell.self, forCellReuseIdentifier: ChatListTableViewCell.className)
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    internal func addView() {
        navigationView.addSubview(navigationLabel)
        
        view.addSubview(channelTableView)
    }
    
    internal func setLayout() {
        
        navigationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(navigationView.snp.bottom).offset(-20)
        }
        
        channelTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
            $0.top.equalTo(navigationView.snp.bottom).offset(20)
        }
    }
    
    internal func addAction() {
        
    }
    private func setupListener() {
        channelStream.subscribe { [weak self] result in
            switch result {
            case .success(let data):
                self?.updateCell(to: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateCell(to data: [(Channel, DocumentChangeType)]) {
        data.forEach { (channel, documentChangeType) in
            switch documentChangeType {
            case .added:
                addChannelToTable(channel)
            case .modified:
                updateChannelInTable(channel)
            case .removed:
                removeChannelFromTable(channel)
            }
        }
    }
    
    private func addChannelToTable(_ channel: Channel) {
        guard channels.contains(channel) == false else { return }
        
        channels.append(channel)
        channels.sort()
        
        guard let index = channels.firstIndex(of: channel) else { return }
        channelTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels[index] = channel
        channelTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels.remove(at: index)
        channelTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.className, for: indexPath) as! ChatListTableViewCell
        cell.setData(channel: channels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        let viewController = ChatRoomViewController(user: currentUser, channel: channel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

