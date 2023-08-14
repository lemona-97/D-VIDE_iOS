//
//  PostReviewViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/08.
//

import Foundation
import Moya

protocol PostReviewBesinessLogic {
    func postReview(postReviewModel: PostReviewModel, img : [Data], completion: @escaping (Result<PostReviewResponse, Error>) -> Void)
}

final class PostReviewViewModel : PostReviewBesinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])

    func postReview(postReviewModel: PostReviewModel, img : [Data], completion: @escaping (Result<PostReviewResponse, Error>) -> Void) {
        realProvider.request(.postReview(postReviewModel: postReviewModel, img: img)) { result in
            switch result {
            case let .success(response):
                print(response.description)
                do {
                    let decoded = try JSONDecoder().decode(PostReviewResponse.self, from: response.data)
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
