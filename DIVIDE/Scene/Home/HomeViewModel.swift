//
//  HomeViewModel.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/08/22.
//

import Foundation
import Moya
import RxSwift



final class HomeViewModel : HomeViewModelBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    func requestAroundPosts(param: UserPosition, skip: Int) -> Single<[Datum]> {
        realProvider.rx.request(.showAroundPost(param: param, skip: skip))
            .filterSuccessfulStatusCodes()
            .map(UserPostsModel.self) // Single<UserPostsModel>
            .flatMap { result in
                    .just(result.data) // .just({something}) -> Single<{something}.type>
            }
    }
    
    func requestAroundPostsWithCategory(param: UserPosition, category: String, skip: Int) -> Single<[Datum]> {
        realProvider.rx.request(.showAroundPostWithCategory(param: param, category: category, skip: skip))
            .filterSuccessfulStatusCodes()
            .map(UserPostsModel.self)
            .flatMap { result in
                    .just(result.data)
            }
    }
    
    
}

