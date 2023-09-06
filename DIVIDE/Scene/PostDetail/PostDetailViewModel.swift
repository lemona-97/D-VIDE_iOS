//
//  PostDetailViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/07/18.
//

import Foundation
import RxSwift
import Moya


final class PostDetailViewModel : PostDetailBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    func requestPostDetail(postId: Int) -> Single<PostDetailModel> {
        realProvider.rx.request(.requestPostDetail(param: postId))
            .filterSuccessfulStatusCodes()
            .map(PostDetailModel.self)
    }
    
    func joinOrder(joinOrder: JoinOrderModel, images: [Data], completion : @escaping (Result<JoinOrderResponse, Error>) -> Void) {
        realProvider.request(.joinOrder(request: joinOrder, img: images)) { result in
            switch result {
            case let .success(response):
                print(response.description)
                do {
                    let decoded = try JSONDecoder().decode(JoinOrderResponse.self, from: response.data)
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
