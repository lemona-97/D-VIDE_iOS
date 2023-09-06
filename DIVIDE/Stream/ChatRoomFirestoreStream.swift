//
//  ChatRoomFirestoreStream.swift
//  DIVIDE
//
//  Created by wooseob on 2023/09/04.
//

import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class ChatRoomFirestoreStream {
    private let storage = Storage.storage().reference()
    let firestoreDatabase = Firestore.firestore()
    var listener: ListenerRegistration?
    lazy var ChatRoomListener: CollectionReference = {
        return firestoreDatabase.collection("chatRooms")
    }()
    lazy var MessageListener: CollectionReference = {
        return firestoreDatabase.collection("messages")
    }()
    func createChatRoom(postId: Int, title : String, foodImgUrl : String,  divider : Int, me : Int, userNickname : String, orderId : Int) {
        var initialField : [String : Any] = [:]
        
        initialField.updateValue(postId, forKey: "postId")
        initialField.updateValue(title, forKey: "title")
        initialField.updateValue(foodImgUrl, forKey: "foodImgUrl")
        initialField.updateValue([divider, me], forKey: "participants")
        initialField.updateValue(["안녕하세요!", userNickname, Timestamp(date: Date.now)] as [Any], forKey: "lastMessage")
        initialField.updateValue(orderId, forKey: "orderId")
        //채팅방 생성
        ChatRoomListener.document("\(orderId)").setData(initialField) { error in
            if let error = error {
                print("Error saving Channel: \(error.localizedDescription)")
            }
        }
        
        MessageListener.document("\(orderId)").setData(["participants" : [divider, me], "postId" : postId])
    }
    
    func subscribe(completion: @escaping (Result<[(ChatRoom, DocumentChangeType)], Error>) -> Void) {
        ChatRoomListener.whereField("participants", arrayContains: UserDefaultsManager.userId)
                        .addSnapshotListener { snaphot, error in
            guard let snapshot = snaphot else {
                completion(.failure(error!))
                return
            }
            let result = snapshot.documentChanges
                .filter { ChatRoom($0.document) != nil }
                .compactMap { (ChatRoom($0.document)!, $0.type) }
                
            
                
            
            completion(.success(result))
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
}
