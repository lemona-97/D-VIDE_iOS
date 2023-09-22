//
//  MyOrderHistoryModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/03.
//

import Foundation

struct MyOrderHistoryModel : Codable {
    var data            : [OrderHistory]
}

// MARK: - Datum
struct OrderHistory: Codable {
    var user            : UserInfo
    var post            : MyOrderPost
    var order           : Order
}

struct Order : Codable {
    var orderedPrice    : Int
    var orderedTime     : Int
}

struct MyOrderPost : Codable {
    /// 내가 주문했던 post의 ID
    var id              : Int
    var longitude       : Double
    var latitude        : Double
    var title           : String
    /// 주문예정 시각
    var targetTime      : Int
    /// 목표 금액
    var targetPrice     : Int
    /// 전체 주문 금액
    var orderedPrice    : Int
    var status          : String
    var postImgUrl      : String
    var storeName       : String
}
