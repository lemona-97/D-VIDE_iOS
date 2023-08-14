//
//  ChatListModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/10.
//


struct ChatListModel {
    var chatId              : String
    var title               : String
    var lastMessage         : String
    var lastMessageTime     : Int // UnixTime : time interval 1970 1 1 00:00
    var foodImageUrl        : String
    var unreadMessagecount  : Int
}

extension ChatListModel: Comparable {
    static func == (lhs: ChatListModel, rhs: ChatListModel) -> Bool {
        return lhs.chatId == rhs.chatId
    }
    
    static func < (lhs: ChatListModel, rhs: ChatListModel) -> Bool {
        return lhs.lastMessageTime < rhs.lastMessageTime
    }
}
