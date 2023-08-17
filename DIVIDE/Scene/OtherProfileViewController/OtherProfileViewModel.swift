//
//  OtherProfileViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/17.
//

import Foundation
import Moya
import RxSwift
protocol OtherProfileBusinessLogic {
    func requestOtherProfile(userId : Int, completion : @escaping (Result<OtherProfileModel, Error>) -> Void)
    func requestOtherReview(userId : Int, first : Int?) -> Single<[Review]>
}

class OtherProfileViewModel : OtherProfileBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    func requestOtherProfile(userId: Int, completion: @escaping (Result<OtherProfileModel, Error>) -> Void) {
        realProvider.request(.requestOtherProfile(userId: userId)) { result in
            switch result {
            case let .success(response):
                print(response.description)
                do {
                    let decoded = try JSONDecoder().decode(OtherProfileModel.self, from: response.data)
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
    
    func requestOtherReview(userId : Int, first : Int?) -> Single<[Review]> {
        realProvider.rx.request(.requestOtherReview(userId: userId, first: first ?? nil))
            .filterSuccessfulStatusCodes()
            .map(OtherReviewData.self)
            .flatMap { response in
                    .just(response.data)
            }
    }
}
