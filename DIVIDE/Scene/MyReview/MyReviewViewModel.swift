//
//  MyReviewViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/09.
//

import Foundation
import Moya
import RxSwift

protocol MyReviewBusinessLogic {
    func requestMyReview(first : Int?) -> Single<[ReviewData]>
}

final class MyReviewViewModel : MyReviewBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])

    func requestMyReview(first : Int?) -> Single<[ReviewData]> {
        realProvider.rx.request(.requestMyReview(first: first))
            .filterSuccessfulStatusCodes()
            .map(UserReviewsModel.self)
            .flatMap { response in
                    .just(response.data)
            }
    }
    
    
}
