//
//  FollowModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/18.
//

import Foundation

struct FollowResponse : Codable {
    var followId  : String?
}

struct UnfollowResponse : Codable {
    var result : Bool?
}
