//
//  CoordinateCacheManager.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/17.
//

import Foundation

class CoordinateCacheManager {
    //키는 경도+위도
    //value는 변환된 주소명
    static let shared = NSCache<NSString, NSString>()
    private init() { CoordinateCacheManager.shared.countLimit = 100 }
}
