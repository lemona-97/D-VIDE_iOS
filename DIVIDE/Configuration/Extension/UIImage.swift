//
//  UIImage.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/07/04.
//

import UIKit
import Photos

extension UIImage {
    func resize(toTargetSize targetSize: CGSize) -> UIImage? {
        let width = (self.size.width / self.size.height < targetSize.width / targetSize.height) ? targetSize.width : (targetSize.width * self.size.width / self.size.height)
        let height = (self.size.height / self.size.width < targetSize.height / targetSize.width) ? targetSize.height : (targetSize.height * self.size.height / self.size.width)
        let target = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(target.size, false, UIScreen.main.scale)
        draw(in: target, blendMode: .normal, alpha: 1)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
        let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = square.width / 2
        imageView.clipsToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    
    var scaledToSafeUploadSize: UIImage? {
        let maxImageSideLength: CGFloat = 480
        let largerSide: CGFloat = max(size.width, size.height)
        let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
        let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
        
        return image(scaledTo: newImageSize)
    }
    
    private func image(scaledTo size: CGSize) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}


