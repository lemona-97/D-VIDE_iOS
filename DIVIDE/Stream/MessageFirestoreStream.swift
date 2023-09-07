//
//  MessageFirestoreStream.swift
//  DIVIDE
//
//  Created by wooseob on 2023/09/05.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class MessageFirestoreStream {
    private let storage = Storage.storage().reference()
    let firestoreDatabase = Firestore.firestore()
    var listener: ListenerRegistration?
    var messageListener: CollectionReference?
    func subscribe(orderId chatRoomId: Int, completion: @escaping (Result<[Message], StreamError>) -> Void) {
        let streamPath = "chatRooms/\(chatRoomId)/message"
        removeListener()
        messageListener = firestoreDatabase.collection(streamPath)
        
        listener = messageListener?.addSnapshotListener { snaphot, error in
                guard let snapshot = snaphot else {
                    completion(.failure(StreamError.firestoreError(error)))
                    return
                }
                var messages = [Message]()
                snapshot.documentChanges.forEach { change in
                    if let message = Message(document: change.document) {
                        if case .added = change.type {
                            messages.append(message)
                        }
                    }
                }
                completion(.success(messages))
            }
    }
    
    func save(_ message: Message, completion: ((Error?) -> Void)? = nil) {
        messageListener?.addDocument(data: message.representation) { error in
                completion?(error)
            }
        }
    func removeListener() {
        listener?.remove()
    }
}
