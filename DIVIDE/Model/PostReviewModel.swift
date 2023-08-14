//
//  PostReviewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/08.
//

import Foundation
import Moya

struct PostReviewModel : Encodable {
    var postId          : Int
    var starRating      : Double
    var content         : String
}

struct PostReviewResponse: Decodable {
    var reviewId : Int
}
