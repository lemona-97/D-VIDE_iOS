//
//  PostStatus.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/08.
//

import Foundation

enum POST_STATUS {
    case RECRUITING
    case RECRUIT_SUCCESS
    case RECRUIT_FAIL
    
    public var value: String {
        switch self {
        case .RECRUITING:
            return "RECRUITING"
        case .RECRUIT_SUCCESS:
            return "RECRUIT_SUCCESS"
        case .RECRUIT_FAIL:
            return "RECRUIT_FAIL"
        }
    }
}
