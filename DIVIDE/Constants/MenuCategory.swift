//
//  MenuCategory.swift
//  DIVIDE
//
//  Created by wooseob on 2023/07/28.
//

import Foundation

//public let categories: [String] = ["분식", "한식", "일식", "중식", "디저트", "양식" ]
//public let categoryName : [String] = ["STREET_FOOD", "KOREAN_FOOD", "JAPANESE_FOOD", "CHINESE_FOOD", "DESSERT", "WESTERN_FOOD"]

enum categories : Int, CaseIterable {
    case STREET_FOOD
    case KOREAN_FOOD
    case JAPANESE_FOOD
    case CHINESE_FOOD
    case DESSERT
    case WESTERN_FOOD
        
    var categoryName : String {
        switch self {
        case .STREET_FOOD:
            return "STREET_FOOD"
        case .KOREAN_FOOD:
            return "KOREAN_FOOD"
        case .JAPANESE_FOOD:
            return "JAPANESE_FOOD"
        case .CHINESE_FOOD:
            return "CHINESE_FOOD"
        case .DESSERT:
            return "DESSERT"
        case .WESTERN_FOOD:
            return "WESTERN_FOOD"
        }
    }
    var category : String {
        switch self {
        case .STREET_FOOD:
            return "분식"
        case .KOREAN_FOOD:
            return "한식"
        case .JAPANESE_FOOD:
            return "일식"
        case .CHINESE_FOOD:
            return "중식"
        case .DESSERT:
            return "디저트"
        case .WESTERN_FOOD:
            return "양식"
        }
    }
}
