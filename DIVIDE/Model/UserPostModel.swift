//
//  UserPostModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/03.
//

import Foundation


// MARK: - UserPostsModel
struct UserPostsModel: Codable {
    var data            : [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    var user            : UserInfo
    var post            : Post
}

// MARK: - Post
struct Post: Codable {
    var id              : Int
    var longitude       : Double
    var latitude        : Double
    var title           : String
    var targetTime      : Int
    var targetPrice     : Int
    var orderedPrice    : Int
    var status          : String
    var postImgUrl      : String

}


// MARK: - User
struct UserInfo: Codable {
    var id              : Int?
    var nickname        : String?
    var profileImgUrl   : String?
  
}
