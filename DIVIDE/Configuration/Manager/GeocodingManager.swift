//
//  GeocodingManager.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/02.
//

import Foundation
import NMapsMap
import SwiftyJSON

enum GeocodingType {
    case SIMPLE
    case DETAIL
}

class GeocodingManager {
    
    /// 리버스 지오코딩 - Using NAVER Maps
    ///
    ///  한달 300만회 (하루 약 10만 회) 까지만 가능
    class func reverseGeocoding(lat: Double, lng: Double,  completion: @escaping (String) -> ()) {
        guard var urlComponents = URLComponents(string: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc") else { return }
        guard let clientID = NMFAuthManager.shared().clientId else { return }
        
        let lng = String(format: "%.5f", lng)
        let lat = String(format: "%.5f", lat)
        
        let queryItemArray = [URLQueryItem(name: "coords", value: lng + "," + lat),
                              URLQueryItem(name: "output", value: "json")]
        
        urlComponents.queryItems = queryItemArray
        
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue(clientID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(naverMapClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                    return
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                do {
                    let row = try JSON(data: data)
                    print(row)
                    
                    let firstAddress = row["results"].arrayValue[0]["region"]["area2"]["name"].stringValue
                    let secondAddress = row["results"].arrayValue[0]["region"]["area3"]["name"].stringValue

                    //건물명은 추후에
//                    let simpleAddress = row["results"].arrayValue[0]["addition0"]["value"].stringValue
//                    + " " + simpleAddress
                    completion(firstAddress + " " + secondAddress)
                    
                    
                } catch(let err) {
                    completion("오류 발생")
                    print("Decoding Error")
                    print(err.localizedDescription)
                }
            }
        }.resume()
    }
}
