//
//  UserDefaultsManager.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/04.
//

import Foundation

struct UserDefaultsManager {
    @UserDefaultWrapper(key: "userPosition", defaultValue: nil)
    static var userPosition: UserPosition?
    @UserDefaultWrapper(key: "appleUserInfo", defaultValue: nil)
    static var appleUserInfo: AppleLoginInfo?
    @UserDefaultWrapper(key: "DIVIDETOKEN", defaultValue: nil)
    static var DIVIDE_TOKEN : String?
    @UserDefaultWrapper(key: "userId", defaultValue: nil)
    static var userId : Int?
    @UserDefaultWrapper(key: "DisplayName", defaultValue: nil)
    static var displayName : String?
}

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    private let key: String
    private let defaultValue: T?
    
    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            // 언아카이빙 정의: JSONDecoder를 이용
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                    return lodedObejct
                }
            }
            
            return defaultValue
        }
        
        set {
            let encoder = JSONEncoder()
            // 아카이빙 정의: JSONEnocder를 이용
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
                
                if key == "userPosition" {
                    print("=========================================================================")
                    print("              User Default : 사용자 기본 주소지 좌표값 등록 완료")
                    print("=========================================================================")
                }
                if key == "appleUserInfo" {
                    print("=========================================================================")
                    print("              Apple User Info : 애플 로그인 정보 저장 완료")
                    print("=========================================================================")
                }

            }
        }
        
    }
    
}
