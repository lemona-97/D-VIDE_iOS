//
//  ShowAroundReviewAPIManager.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/12/22.
//

import Foundation
import Moya
import RxSwift

protocol ReviewBusinessLogic {
    
    /// 주변 가게의 리뷰 정보 조회
    func requestAroundReviews(param: UserPosition) -> Single<[ReviewData]>
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
}

