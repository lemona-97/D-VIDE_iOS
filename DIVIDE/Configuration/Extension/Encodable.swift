//
//  Encodable.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/10.
//

import Foundation

extension Encodable {
    var asDictionary: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self),
              let dictinoary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return nil }
        return dictinoary
    }
}
