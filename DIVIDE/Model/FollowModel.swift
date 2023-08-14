//
//  FollowModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/09.
//

import Foundation

struct FollowResponse : Decodable {
    var data            : [FollowInfo]
}

struct FollowInfo : Decodable {
    var userId          : Int?
    var profileImgUrl   : String?
    var nickname        : String?
    var followId        : Int?
}
