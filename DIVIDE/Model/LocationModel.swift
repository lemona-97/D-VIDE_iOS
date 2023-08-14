//
//  LocationModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/07/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   var locationModel = try LocationModel(json)

import Foundation
import SwiftyJSON
// MARK: - LocationModel
struct LocationModel {
    var status      : Status?
    var results     : Results?
    
    init() {}
    
    init(json : JSON) {
        status      = Status(json: json)
        results     = Results(json: json)
    }
    
}

// MARK: - Result
struct Results {
    var name        : String = ""
    var code        : Code?
    var region      : Region?
    
    init() {}
    
    init(json: JSON) {
        name        = json["name"].stringValue
        code        = Code(json: json)
        region      = Region(json: json)
    }
}

// MARK: - Code
struct Code {
    var id          : String = ""
    var type        : String = ""
    var mappingId   : String = ""
    
    init(json: JSON){
        id          = json["id"].stringValue
        type        = json["type"].stringValue
        mappingId   = json["mappingID"].stringValue
    }
}

// MARK: - Region
struct Region {
    var area0       : Area?
    var area1       : Area?
    var area2       : Area?
    var area3       : Area?
    var area4       : Area?
    
    
    init(json: JSON) {
        area0       = Area(json: json)
        area1       = Area(json: json)
        area1       = Area(json: json)
        area1       = Area(json: json)
        area1       = Area(json: json)
    }
}

// MARK: - Area
struct Area {
    var name        : String    = ""
    var coords      : Coords?
    
    init(json: JSON) {
        name        = json["name"].stringValue
        coords      = Coords(json: json)
    }
}

// MARK: - Coords
struct Coords {
    var center      : Center?
    init(json: JSON) {
        center      = Center(json: json)
    }
}

// MARK: - Center
struct Center {
    var crs         : String    = ""
    var x           : Float     = 0.0
    var y           : Float     = 0.0
    
    init () {}
    
    init(json: JSON) {
        self.crs    = json["crs"].stringValue
        self.x      = json["x"].floatValue
        self.y      = json["y"].floatValue
    }
}

// MARK: - Status
struct Status {
    var code        : Int       = 0
    var name        : String    = ""
    var message     : String    = ""
    
    init () {}
    
    init(json: JSON) {
        code        = json["code"].intValue
        name        = json["name"].stringValue
        message     = json["message"].stringValue
    }
}
