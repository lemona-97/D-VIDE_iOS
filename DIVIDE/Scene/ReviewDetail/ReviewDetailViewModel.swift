//
//  ReviewDetailViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/02.
//

import Foundation
import Moya
import RxSwift

protocol ReviewDetailBusinessLogic {
    func requestReviewDetail(reviewId: Int) -> Single<ReviewDetailModel>
}

final class ReviewDetailViewModel: ReviewDetailBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    func requestReviewDetail(reviewId : Int) -> Single<ReviewDetailModel> {
        realProvider.rx.request(.requestReviewDetail(reviewId: reviewId))
            .filterSuccessfulStatusCodes()
            .map(ReviewDetailModel.self)
    }
}
