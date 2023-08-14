//
//  ImageMediaItem.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/10.
//

import UIKit
import MessageKit

struct ImageMediaItem: MediaItem {
  var url: URL?
  var image: UIImage?
  var placeholderImage: UIImage
  var size: CGSize

  init(image: UIImage) {
    self.image = image
    self.size = CGSize(width: 240, height: 240)
    self.placeholderImage = UIImage()
  }
}
