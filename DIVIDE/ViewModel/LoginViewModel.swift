//
//  LoginViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/07.
//

import Foundation
import Moya

protocol LoginBusinessLogic {
    /// 카카오 로그인 시 서버에서 자동으로 회원 가입 후 ->  토큰 & userId 제공
    func kakaoSignUp(accessToken : String, completion: @escaping (Result<LoginResponse, Error>) -> Void)
    
    ///  자체 회원 가입
    func divideSignUp(signUpInfo : SignUpModel, img : Data, completion: @escaping (Result<SignUpResponse, Error>) -> Void)
    
    ///  자체 로그인
    func divideSignIn(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void)
    func setUserPositon(userPosition : UserPosition, completion : @escaping () -> Void)
}

class LoginViewModel : LoginBusinessLogic {
    
    
    
    
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    // 로그인 자동으로 됨
    func kakaoSignUp(accessToken : String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        realProvider.request(.kakaoSignUp(accesstoken: accessToken)) { result in
            switch result {
            case let .success(response):
                print(response.description)
                do {
                    let decoded = try JSONDecoder().decode(LoginResponse.self, from: response.data)
                    completion(.success(decoded))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    func divideSignIn(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        realProvider.request(.divideSignIn(email: email, password: password)) { result in
            switch result {
            case let .success(response):
                print(response.description)
                do {
                    let decoded = try JSONDecoder().decode(LoginResponse.self, from: response.data)
                    completion(.success(decoded))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    func divideSignUp(signUpInfo: SignUpModel, img: Data, completion: @escaping (Result<SignUpResponse, Error>) -> Void) {
        realProvider.request(.divideSignUp(signUpInfo: signUpInfo, img: img)) { result in
            switch result {
            case let .success(response):
                print(response.description)
                do {
                    let decoded = try JSONDecoder().decode(SignUpResponse.self, from: response.data)
                    completion(.success(decoded))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
    
    func setUserPositon(userPosition: UserPosition, completion : @escaping () -> Void ) {
        realProvider.request(.setUserPosition(position: userPosition)) { result in
            print("=========================================================================")
            print("                          최초 유저 위치 설정 결과")
            switch result {
            case let .success(reponse):
                completion()
                print(reponse)
            case let .failure(error):
                print(error.localizedDescription)
            }
            print("=========================================================================")
        }
    }
}
