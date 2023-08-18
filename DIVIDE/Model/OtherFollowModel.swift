//
//  OtherFollowModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/18.
//

import Foundation

struct OtherFollowResponse : Codable {
    var data : [OtherFollowModel]
}

struct OtherFollowModel : Codable {
    var userId          : Int?
    var profileImgUrl   : String?
    var nickname        : String?
    var followed        : Bool?
    var followId        : Int?
}
