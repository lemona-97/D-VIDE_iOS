//
//  MeasureTime.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/17.
//

import Foundation

public func measureTime(_ closure: () -> ()) -> TimeInterval {
    let startDate = Date()
    closure()
    return Date().timeIntervalSince(startDate)
}
