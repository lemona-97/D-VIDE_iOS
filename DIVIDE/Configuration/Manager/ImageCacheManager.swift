//
//  ImageCacheManager.swift
//  DIVIDE
//
//  Created by wooseob on 2023/07/31.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() { ImageCacheManager.shared.countLimit = 50 }
}
