//
//  ReviewDetailModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/03.
//

import Foundation

// MARK: - UserReviewDetailModel
struct ReviewDetailModel: Codable {
    var data: ReviewDetailData
}

struct ReviewDetailData: Codable {
    var user: UserInfo
    var reviewDetail: ReviewDetail
}

// MARK: - Reviews
struct ReviewDetail: Codable {
    var reviewId        : Int
    var longitude       : Double
    var latitude        : Double
    var content         : String
    var starRating      : Double
    var reviewImgUrl    : [String]
    var storeName       : String
    var likeCount       : Int
    var isLiked         : Bool
}
