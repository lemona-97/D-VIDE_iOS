//
//  PostRecrutingResponse.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/08/09.
//

import Foundation
import Moya

final class PostRecruitingViewModel : PostRecruitingBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    func requestpostRecruiting(param: PostRecruitingInput, img: [Data], completion: @escaping (Result<PostRecruitingResponse, Error>) -> Void) {
        realProvider.request(.postRecruiting(param: param, img: img)) { result in
            switch result {
            case let .success(response):
                print(response.description)
                do {
                    let decoded = try JSONDecoder().decode(PostRecruitingResponse.self, from: response.data)
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
