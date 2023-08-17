//
//  OtherProfileModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/17.
//

import Foundation


struct OtherProfileModel : Decodable {
    var profileImgUrl   : String?
    var nickname        : String?
    var badge          : Badge?
    var followerCount   : Int?
    var followingCount  : Int?
    var followed        : Bool?
}
