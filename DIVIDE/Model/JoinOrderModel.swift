//
//  JoinOrderModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/09.
//

import Foundation


struct JoinOrderModel : Codable {
    var postId      : Int
    var orderPrice  : Int
}

struct JoinOrderResponse : Decodable {
    var orderId     : Int
}
