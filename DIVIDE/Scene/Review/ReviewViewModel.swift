//
//  ShowAroundReviewAPIManager.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/12/22.
//

import Foundation
import Moya
import RxSwift

protocol reviewLikeLogic {
    func requestReviewLike(reviewId : Int, completion : @escaping (Result<ReviewLikeResponse, Error>) -> Void)
    func requestReviewUnLike(reviewId : Int, completion : @escaping (Result<ReviewUnLikeResponse, Error>) -> Void)
}
protocol ReviewBusinessLogic : reviewLikeLogic {
    
    /// 주변 가게의 리뷰 정보 조회
    func requestAroundReviews(param: UserPosition) -> Single<[ReviewData]>
    
    /// 리뷰 좋아요 누르기
    

}

final class ReviewViewModel : ReviewBusinessLogic {
    
    
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    //    var postsFromServer = PublishSubject<[Datum]>()
    func requestAroundReviews(param: UserPosition) -> Single<[ReviewData]> {
        realProvider.rx.request(.showAroundReviews(param: param))
            .filterSuccessfulStatusCodes()
            .map(UserReviewsModel.self) // Single<UserReviewsModel>
            .flatMap { result in
                    .just(result.data) // .just({something}) -> Single<{something}.type>
            }
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

