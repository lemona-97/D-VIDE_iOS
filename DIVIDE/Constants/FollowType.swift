//
//  FollowType.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/08.
//

import Foundation

enum FollowType {
    case FOLLOWER
    case FOLLOWING

    public var value: String {
        switch self {
        case .FOLLOWER:
            return "FOLLOWER"
        case .FOLLOWING:
            return "FOLLOWING"

        }
    }
}
