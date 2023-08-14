//
//  PostDetailModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/07/18.
//

import Foundation
import SwiftyJSON

struct PostDetailModel : Codable {
    var data            : PostDetailData?

}

struct PostDetailData : Codable {
    var user            : UserInfo?
    var postDetail      : PostDetail?
    var ordered         : Bool?

}

struct PostDetail : Codable  {
    var id              : Int?
    var longitude       : Double?
    var latitude        : Double?
    var title           : String?
    var targetTime      : Int?
    var targetPrice     : Int?
    var deliveryPrice   : Int?
    var orderedPrice    : Int?
    var content         : String?
    var storeName       : String?
    var postImgUrls     : [String]?
    
}

