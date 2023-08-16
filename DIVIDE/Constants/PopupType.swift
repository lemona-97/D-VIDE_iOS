//
//  PopupType.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/16.
//

import Foundation

enum PopupType {
    case ALERT
    case SELECT

    public var value: String {
        switch self {
        case .ALERT:
            return "ALERT"
        case .SELECT:
            return "SELECT"

        }
    }
}
