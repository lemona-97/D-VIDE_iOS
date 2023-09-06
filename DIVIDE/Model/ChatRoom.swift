//
//  Channel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/10.
//

import Foundation
import FirebaseFirestore

struct ChatRoom {
    let foodImgUrl : String?
    let lastMessage : [Any]?
    let participants : [Int]?
    let title: String?
    let postId: Int?
    let orderId : Int?

    init(foodImgUrl: String? = nil, lastMessage: [Any]? = nil, participants: [Int]? = nil, title: String? = nil, postId: Int? = nil, orderId : Int) {
        self.foodImgUrl = foodImgUrl
        self.lastMessage = lastMessage
        self.participants = participants
        self.title = title
        self.postId = postId
        self.orderId = orderId
    }

    init?(_ document: QueryDocumentSnapshot) {
        let data = document.data()

        guard let postId = data["postId"] as? Int else {
            return nil
        }
        guard let foodImgUrl = data["foodImgUrl"] as? String else {
            return nil
        }
        guard let lastMessage = data["lastMessage"] as? [Any] else {
            return nil
        }
        guard let participants = data["participants"] as? [Int] else {
            return nil
        }
        guard let title = data["title"] as? String else {
            return nil
        }
        guard let orderId = data["orderId"] as? Int else {
            return nil
        }
        self.postId = postId
        self.foodImgUrl = foodImgUrl
        self.lastMessage = lastMessage
        self.participants = participants
        self.title = title
        self.orderId = orderId
    }
}

extension ChatRoom: DatabaseRepresentation {
    var representation: [String: Any] {
        var rep = ["postId": postId]
        
        if let postId = postId {
            rep["postId"] = postId
        }
        
        return rep
    }
}

extension ChatRoom: Comparable {
    static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.orderId == rhs.orderId
    }
    
    static func < (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        guard let left = lhs.orderId, let right = rhs.orderId else { return false }
        return left < right
    }
}
