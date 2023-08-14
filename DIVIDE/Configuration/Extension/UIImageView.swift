//
//  UIImageView.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/07/04.
//

import UIKit
import Photos

extension UIImageView {
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            if let image = image {
                self.image = image
                self.clipsToBounds = true
                if contentMode == .aspectFill {
                    self.contentMode = .scaleAspectFill
                } else if contentMode == .aspectFit {
                    self.contentMode = .scaleAspectFit
                }
            }
        }
    }
    /// ImageView의 이미지를 URL값으로 부터 로딩
    ///
    /// URL -> Data 는 global
    ///
    /// Data -> Image는 main
    func load(url: String, completion: @escaping () -> Void) {
        
        let cacheKey = NSString(string: url)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            print("캐시에 있는 사진입니다. url 로드를 하지 않고 캐시에서 불러옵니다.")
            completion()
            return
        }
        print("캐시에 없는 사진입니다. url 로드를 진행하고 캐시에 저장합니다.")
        guard let url = URL(string: url) else {
            completion()
            return }
        
        DispatchQueue.global().async { [weak self] in
            
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                        self?.image = image
                        completion()
                    }
                }
            }
        }
    }
}
