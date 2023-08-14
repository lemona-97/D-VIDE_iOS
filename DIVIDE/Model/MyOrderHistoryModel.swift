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
    var id              : Int
    var longitude       : Double
    var latitude        : Double
    var title           : String
    var targetTime      : Int
    var targetPrice     : Int
    var orderedPrice    : Int
    var status          : String
    var postImgUrl      : String
    var storeName       : String
}
