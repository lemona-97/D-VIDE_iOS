//
//  LoginModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/07.
//

import Foundation


struct LoginResponse : Decodable {
    var token       : String
    var userId      : Int
}

/// 회원가입 모델 (추후에 payload로 변경예정)
///
/// 프로필 이미지는 multifpart로 보냄
struct SignUpModel : Encodable {
    var email       : String
    var password    : String
    var nickname    : String
}

struct SignUpResponse : Decodable {
    var userId      : Int
}
