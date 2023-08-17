//
//  CoordinateCacheManager.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/17.
//

import Foundation

class CoordinateCacheManager {
    static let shared = NSCache<NSString, NSString>()
    private init() { CoordinateCacheManager.shared.countLimit = 100 }
}
