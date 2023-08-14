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

struct SignUpModel : Encodable {
    var email       : String
    var password    : String
    //프로필 이미지는 multifpart로
    var nickname    : String
}

struct SignUpResponse : Decodable {
    var userId      : Int
}
