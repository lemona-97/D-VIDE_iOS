//
//  ChatRoomViewController.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/10.
//

import UIKit
import Then
import SnapKit

import MessageKit
import InputBarAccessoryView
import PhotosUI
import FirebaseAuth
class ChatRoomViewController: MessagesViewController {
    
    //property
    
    let channel: Channel
    var sender = Sender(senderId: String(UserDefaultsManager.userId!), displayName: "우섭")
    var messages = [Message]()
    let chatFirestoreStream = ChatFirestoreStream()
    private let user : User
    
    init(user: User, channel: Channel) {
           self.user = user
           self.channel = channel
           super.init(nibName: nil, bundle: nil)
           
           title = channel.name
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
        setAttributes()
        addAction()
        removeOutgoingMessageAvatars()
        addCameraBarButtonToMessageInputBar()
        listenToMessages()
    }
    
    private func setUp() {
        
    }
    private func setAttributes() {
        messagesCollectionView.do {
            $0.messagesDataSource = self
            $0.messagesLayoutDelegate = self
            $0.messagesDisplayDelegate = self
        }
        
        messageInputBar.do {
            $0.delegate = self
            $0.inputTextView.tintColor = .mainOrange1
            $0.sendButton.setTitleColor(.mainOrange1, for: .normal)
            $0.inputTextView.placeholder = "Aa"
        }
        
        cameraBarButtonItem.do {
            $0.tintColor = .mainOrange1
            $0.image = UIImage(systemName: "camera")
        }
    }
    // Custom VC라 미 작성
    //    private func addView() {
    //
    //    }
    //
    //    private func setLayout() {
    //
    //    }
    
    private func addAction() {
        cameraBarButtonItem.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.photoConfiguration.filter = .any(of: [.images])
            self.photoConfiguration.selectionLimit = 3
            let picker = PHPickerViewController(configuration: photoConfiguration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }), for: .touchUpInside)
    }
    
    private func removeOutgoingMessageAvatars() {
        guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.setMessageOutgoingAvatarSize(.zero)
        let outgoingLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
        layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
    }
    
    private func addCameraBarButtonToMessageInputBar() {
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraBarButtonItem], forStack: .left, animated: false)
    }
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messages.sort()
        
        messagesCollectionView.reloadData()
    }
    
    private func listenToMessages() {
        guard let id = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        chatFirestoreStream.subscribe(id: id) { [weak self] result in
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
           FirebaseStorageManager.uploadImage(image: image, channel: channel) { [weak self] url in
               self?.isSendingPhoto = false
               guard let user = self?.user, let url = url else { return }
               
               var message = Message(user: user, image: image)
               message.downloadURL = url
               self?.chatFirestoreStream.save(message)
               self?.messagesCollectionView.scrollToLastItem()
           }
       }
}
