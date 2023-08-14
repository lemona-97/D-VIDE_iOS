//
//  NSObject.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/10.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
