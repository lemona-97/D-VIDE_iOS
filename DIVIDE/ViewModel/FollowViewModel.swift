//
//  FollowViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/08.
//

import Foundation
import Moya
import RxSwift

protocol FollowBusinessLogic {
    func requestFollowList(type: FollowType, first : Int?) -> Single<[FollowInfo]>
}

final class FollowViewModel : FollowBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    func requestFollowList(type: FollowType, first: Int?) -> Single<[FollowInfo]> {
        realProvider.rx.request(.requestFollow(relation: type, first: first))
            .filterSuccessfulStatusCodes()
            .map(FollowResponse.self) // Single<FollowResponse>
            .flatMap { result in
                    .just(result.data)
            }
    }
    
    
}
