//
//  HomeModel.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/08/22.
//

import Foundation


class UserPosition: Codable {
    var longitude       : Double
    var latitude        : Double
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
}




