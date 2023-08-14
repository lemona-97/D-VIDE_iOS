//
//  ReviewModel.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/12/28.
//

import Foundation



// MARK: - UserReviewsModel
struct UserReviewsModel: Codable {
    var data                : [ReviewData]
}

// MARK: - Datum
struct ReviewData: Codable {
    var user                : UserInfo
    var review              : Review
}

// MARK: - Reviews
struct Review: Codable {
    var reviewId            : Int
    var longitude           : Double
    var latitude            : Double
    var content             : String
    var starRating          : Double
    var reviewImgUrl        : String
    var storeName           : String
    var likeCount           : Int
    var isLiked             : Bool
}


struct ReviewLikeResponse : Decodable {
    var reviewLikeId        : Int
}

struct ReviewUnLikeResponse : Decodable {
    var reviewId            : Int
}
