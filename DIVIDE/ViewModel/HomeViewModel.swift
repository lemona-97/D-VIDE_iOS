//
//  HomeViewModel.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/08/22.
//

import Foundation
import Moya
import RxSwift


protocol HomeViewModelBusinessLogic {
    /// 주변 500m내의 게시글 조회
    ///
    /// 카테고리에 상관없음
    func requestAroundPosts(param: UserPosition) -> Single<[Datum]>
    
    /// 주변 500m 내에 해당 카테고리의 게시글 조회
    ///
    /// 카테고리 설정하여 게시글 호출
    func requestAroundPostsWithCategory(param: UserPosition, category: String) -> Single<[Datum]>
    
    

}

class HomeViewModel : HomeViewModelBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    func requestAroundPosts(param: UserPosition) -> Single<[Datum]> {
        realProvider.rx.request(.showAroundPost(param: param))
            .filterSuccessfulStatusCodes()
            .map(UserPostsModel.self) // Single<UserPostsModel>
            .flatMap { result in
                    .just(result.data) // .just({something}) -> Single<{something}.type>
            }
    }
    
    func requestAroundPostsWithCategory(param: UserPosition, category: String) -> Single<[Datum]> {
        realProvider.rx.request(.showAroundPostWithCategory(param: param, category: category))
            .filterSuccessfulStatusCodes()
            .map(UserPostsModel.self)
            .flatMap { result in
                    .just(result.data)
            }
    }
    
    
}

