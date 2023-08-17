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
    // 조회 숫자 제한 기능 필요 소수점 3자리까지..?
    
    /// 리버스 지오코딩 - Using NAVER Maps
    ///
    ///  한달 300만회 (하루 약 10만 회) 까지만 가능
    class func reverseGeocoding(lat: Double, lng: Double,  completion: @escaping (String) -> ()) {
        
        let lng = String(format: "%.4f", lng)
        let lat = String(format: "%.4f", lat)
        
        let cacheKey = (lng + lat) as NSString
        
        if let cachedCoordinate = CoordinateCacheManager.shared.object(forKey: cacheKey) {
            
            print("캐시에 있는 좌표입니다. 리버스 지오코딩을 하지 않고 캐시에서 불러옵니다.")
            completion(cachedCoordinate as String)
        }
        print("캐시에 없는 좌표입니다. 리버스 지오코딩을 진행하고 캐시에 저장합니다.")
        
        guard var urlComponents = URLComponents(string: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc") else { return }
        guard let clientID = NMFAuthManager.shared().clientId else { return }
        
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
                    let totalAddress = firstAddress + " " + secondAddress
                    CoordinateCacheManager.shared.setObject((totalAddress) as NSString, forKey: cacheKey)
                    completion(totalAddress)
                    
                    
                } catch(let err) {
                    completion("오류 발생")
                    print("Decoding Error")
                    print(err.localizedDescription)
                }
            }
        }.resume()
    }
}
