//
//  ProfileModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/03.
//

import Foundation
import Moya
/// 프로필 조회용 Model
struct ProfileModel : Codable {
    var userId              : Int
    var profileImgUrl       : String
    var nickname            : String
    var badge               : Badge
    var email               : String
    var followerCount       : Int
    var followingCount      : Int
    var savedPrice          : Int
    var location            : UserPosition
}

struct Badge : Codable {
    var name                : String
    var description         : String
}

/// 프로필 수정 요청 Model
struct ModifyProfileModel : Codable {
    
    var nickname            : String?
    var badgeName           : String?
    var latitude            : Double?
    var longitude           : Double?
}
