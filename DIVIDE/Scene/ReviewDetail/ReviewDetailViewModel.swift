//
//  ReviewDetailViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/02.
//

import Foundation
import Moya
import RxSwift


final class ReviewDetailViewModel: ReviewDetailBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    func requestReviewDetail(reviewId : Int) -> Single<ReviewDetailModel> {
        realProvider.rx.request(.requestReviewDetail(reviewId: reviewId))
            .filterSuccessfulStatusCodes()
            .map(ReviewDetailModel.self)
    }
    
    func requestReviewLike(reviewId: Int, completion : @escaping (Result<ReviewLikeResponse, Error>) -> Void) {
        realProvider.request(.requestReivewLike(reviewId: reviewId)) { result in
            switch result {
            case let .success(response):
                print(response.description)
                do {
                    let decoded = try JSONDecoder().decode(ReviewLikeResponse.self, from: response.data)
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
    
    func requestReviewUnLike(reviewId : Int, completion : @escaping (Result<ReviewUnLikeResponse, Error>) -> Void) {
        realProvider.request(.requestReviewUnlike(reviewId: reviewId)) { result in
            switch result {
            case let .success(response):
                print(response.description)
                do {
                    let decoded = try JSONDecoder().decode(ReviewUnLikeResponse.self, from: response.data)
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
