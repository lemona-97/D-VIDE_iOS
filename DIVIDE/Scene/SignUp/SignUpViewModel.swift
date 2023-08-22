//
//  SignUpViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/16.
//

import Foundation
import Moya

protocol SignUpBusinessLogic : DIVIDELoginLogic {
    
    func requestSignUp(signUpInfo: SignUpModel, imageData : Data, completion: @escaping (Result<SignUpResponse, Error>) -> Void)
    func divideSignIn(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void)
}

final class SignUpViewModel : SignUpBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    func requestSignUp(signUpInfo: SignUpModel, imageData : Data, completion: @escaping (Result<SignUpResponse, Error>) -> Void) {
        realProvider.request(.divideSignUp(signUpInfo: signUpInfo, img: imageData)) { result in
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
}
