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
import FirebaseCore
final class ChatListViewController: DVIDEViewController1, ViewControllerFoundation {
    
    private let navigationLabel         = MainLabel(type: .hopang)
    
    private var chatRooms               = [ChatRoom]()
    private var disposeBag              = DisposeBag()
    //    private var viewModel               =
    
    lazy var   currentUser              = Auth.auth().currentUser!
    init() {
        super.init(nibName: nil, bundle: nil)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        chatRoomStream.removeListener()
    }
    private let chatRoomTableView         = UITableView()
    private let chatRoomStream            = ChatRoomFirestoreStream()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        setAttribute()
        addView()
        setLayout()
        
        setupListener()
    }
    
    internal func setUp() {
        
    }
    
    internal func setAttribute() {
        navigationLabel.do {
            $0.text = "D/VIDE 채팅"
            $0.textAlignment = .center
        }
        
        chatRoomTableView.do {
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
        
        view.addSubview(chatRoomTableView)
    }
    
    internal func setLayout() {
        
        navigationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(navigationView.snp.bottom).offset(-20)
        }
        
        chatRoomTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
            $0.top.equalTo(navigationView.snp.bottom).offset(20)
        }
    }
    
    internal func addAction() {
        
    }
    private func setupListener() {
        chatRoomStream.subscribe { [weak self] result in
            switch result {
            case .success(let data):
                self?.updateCell(to: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateCell(to data: [(ChatRoom, DocumentChangeType)]) {
        data.forEach { (chatRoom, documentChangeType) in
            switch documentChangeType {
            case .added:
                addChatRoomToTable(chatRoom)
            case .modified:
                updateChatRoomInTable(chatRoom)
            case .removed:
                removeChatRoomFromTable(chatRoom)
            }
        }
    }
    
    private func addChatRoomToTable(_ chatRoom: ChatRoom) {
        print("add Chat Room")
        guard chatRooms.contains(chatRoom) == false else { print("add failed.", chatRoom); return }
        
        chatRooms.append(chatRoom)
        chatRooms.sort()
        
        guard let index = chatRooms.firstIndex(of: chatRoom) else { return }
        chatRoomTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        print("chat Room list : ", chatRooms)
    }
    
    private func updateChatRoomInTable(_ chatRoom: ChatRoom) {
        print("update Chat Room")
        guard let index = chatRooms.firstIndex(of: chatRoom) else { return }
        chatRooms[index] = chatRoom
        chatRoomTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        print("chat Room list : ", chatRooms)
    }
    
    private func removeChatRoomFromTable(_ chatRoom: ChatRoom) {
        print("remove Chat Room")
        guard let index = chatRooms.firstIndex(of: chatRoom) else { return }
        chatRooms.remove(at: index)
        chatRoomTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.className, for: indexPath) as! ChatListTableViewCell
        cell.setData(chatRoom: chatRooms[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoom = chatRooms[indexPath.row]
        let viewController = ChatRoomViewController(user: currentUser, chatRoom: chatRoom)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

