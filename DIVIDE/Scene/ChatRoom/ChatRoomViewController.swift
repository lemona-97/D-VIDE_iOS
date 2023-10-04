//
//  ChatRoomViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/10.
//

import MessageKit
import InputBarAccessoryView
import PhotosUI
import FirebaseAuth
import SnapKit
import Then
final class ChatRoomViewController: MessagesViewController, ViewControllerFoundation {
    
    //property
    let chatRoom: ChatRoom
    var sender = Sender(senderId: String(UserDefaultsManager.userId!), displayName: UserDefaultsManager.displayName!)
    var messages = [Message]()
    let chatFirestoreStream = MessageFirestoreStream()
    private let user : User
    
    let navBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 44))
    
    init(user: User, chatRoom: ChatRoom) {
        self.user = user
        self.chatRoom = chatRoom
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        chatFirestoreStream.removeListener()
        
    }
    // Photo
    private let cameraBarButtonItem = InputBarButtonItem(type: .system)
    private var photoConfiguration  = PHPickerConfiguration()
    private var isSendingPhoto = false {
        didSet {
            messageInputBar.leftStackViewItems.forEach { item in
                guard let item = item as? InputBarButtonItem else {
                    return
                }
                DispatchQueue.main.async {
                    item.isEnabled = !self.isSendingPhoto
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setAttribute()
        addAction()
        removeOutgoingMessageAvatars()
//        addCameraBarButtonToMessageInputBar()
        listenToMessages()

    }
    
    internal func setUp() {
        
    }
    internal func setAttribute() {
        
        messagesCollectionView.do {
            $0.messagesDataSource = self
            $0.messagesLayoutDelegate = self
            $0.messagesDisplayDelegate = self
            $0.backgroundColor = .viewBackgroundGray
            $0.contentInset = .init(top: 40, left: 0, bottom: 0, right: 0)
        }

        messageInputBar.do {
            $0.delegate = self
            $0.inputTextView.tintColor = .mainOrange1
            $0.sendButton.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
            $0.sendButton.setImage(UIImage(systemName: "arrow.up.circle"), for: .selected)
            $0.sendButton.setImage(UIImage(systemName: "arrow.up.circle"), for: .highlighted)
            $0.sendButton.tintColor = .mainOrange1
            $0.sendButton.setTitle(nil, for: .normal)
            $0.inputTextView.placeholder = "메시지를 입력하세요"
            $0.inputTextView.backgroundColor = .white
            $0.leftStackView.backgroundColor = .white
            $0.backgroundView.backgroundColor = .white
            $0.inputTextView.textColor = .mainOrange2
        }
        
        
        cameraBarButtonItem.do {
            $0.tintColor = .mainOrange1
            $0.image = UIImage(systemName: "camera")
        }
        
        setUpNavBar()
        
    }
    internal func addView() {
        
    }
    internal func setLayout() {
        
        
    }
    
    internal func addAction() {
        cameraBarButtonItem.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.photoConfiguration.filter = .any(of: [.images])
            self.photoConfiguration.selectionLimit = 3
            let picker = PHPickerViewController(configuration: photoConfiguration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }), for: .touchUpInside)
    }
    private func setUpNavBar() {
        self.view.addSubview(navBar)
        navBar.items?.append(UINavigationItem(title: ""))
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(onCancel))
        backButton.tintColor = .black
        
        navBar.topItem?.leftBarButtonItem = backButton
        navBar.barTintColor = .mainOrange1
    }
    private func removeOutgoingMessageAvatars() {
        guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.setMessageOutgoingAvatarSize(.zero)
        let outgoingLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
        layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
    }
    
    private func addCameraBarButtonToMessageInputBar() {
//        messageInputBar.leftStackView.alignment = .center
//        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
//        messageInputBar.setStackViewItems([cameraBarButtonItem], forStack: .left, animated: false)
    }
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messages.sort()
        print("insert \(message)")
        messagesCollectionView.reloadData()
    }
    
    private func listenToMessages() {
        guard let orderId = self.chatRoom.orderId else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        chatFirestoreStream.subscribe(orderId: orderId) { [weak self] result in
            switch result {
            case .success(let messages):
                self?.loadImageAndUpdateCells(messages)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadImageAndUpdateCells(_ messages: [Message]) {
        messages.forEach { message in
            var message = message
            if let url = message.downloadURL {
                FirebaseStorageManager.downloadImage(url: url) { [weak self] image in
                    guard let image = image else { return }
                    message.image = image
                    self?.insertNewMessage(message)
                }
            } else {
                insertNewMessage(message)
            }
        }
    }
    
    @objc
    func onCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ChatRoomViewController : MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    // DataSource
    var currentSender: MessageKit.SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1),
                                                             .foregroundColor: UIColor(white: 0.3, alpha: 1)])
    }
    
    // LayoutDelegate
    
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    // DisplayDelegate
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .mainOrange1 : .white
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(cornerDirection, .curved)
    }
    
}

extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(user: user, content: text)
        
        chatFirestoreStream.save(message) { [weak self] error in
            if let error = error {
                print(error)
                return
            }
            self?.messagesCollectionView.scrollToLastItem()
        }
        inputBar.inputTextView.text.removeAll()
    }
}


extension ChatRoomViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // picker 닫고
        picker.dismiss(animated: true)
        
        results.forEach { result in
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
                result.itemProvider.loadObject(ofClass: UIImage.self) { (newImage, error) in // 4
                    let newImage = newImage as! UIImage
                    self.sendPhoto(newImage)
                }
            } else {
                // TODO: Handle empty results or item provider not being able load UIImage
                print("가져온 사진이 없음")
            }
        }
        
    }
    
    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true
        FirebaseStorageManager.uploadImage(image: image, chatRoom:  chatRoom) { [weak self] url in
            self?.isSendingPhoto = false
            guard let user = self?.user, let url = url else { return }
            
            var message = Message(user: user, image: image)
            message.downloadURL = url
            self?.chatFirestoreStream.save(message)
            self?.messagesCollectionView.scrollToLastItem()
        }
    }
}
