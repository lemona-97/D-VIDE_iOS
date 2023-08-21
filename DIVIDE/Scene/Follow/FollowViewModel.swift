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
    func requestOtherFollowList(relation : FollowType, first : Int?, userId : Int) -> Single<[OtherFollowModel]>

}

final class FollowViewModel : FollowBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    func requestFollowList(type: FollowType, first: Int?) -> Single<[FollowInfo]> {
        realProvider.rx.request(.requestFollow(relation: type, first: first))
            .filterSuccessfulStatusCodes()
            .map(FollowListResponse.self) // Single<FollowListResponse>
            .flatMap { result in
                    .just(result.data)
            }
    }
    
    func requestOtherFollowList(relation: FollowType, first: Int?, userId: Int) -> Single<[OtherFollowModel]> {
        realProvider.rx.request(.requestOtherFollow(relation: relation, first: first ?? nil, userId: userId))
            .filterSuccessfulStatusCodes()
            .map(Array<OtherFollowModel>.self)
            .do()
    }
}
