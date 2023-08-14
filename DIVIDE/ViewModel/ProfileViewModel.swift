//
//  ProfileViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/03.
//

import Foundation
import Moya
import RxSwift

protocol ProfileBusinessLogic {
    
    /// 주변 가게의 리뷰 정보 조회
    func requestMyProfile() -> Single<ProfileModel>
    func modifyMyProfile(profile : ModifyProfileModel, img : Data?, completion: @escaping () -> Void)
    
}

final class ProfileViewModel : ProfileBusinessLogic {
    
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])
    
    //    var postsFromServer = PublishSubject<[Datum]>()
    func requestMyProfile() -> Single<ProfileModel> {
        realProvider.rx.request(.requestMyProfile)
            .filterSuccessfulStatusCodes()
            .map(ProfileModel.self)
    }
    
    func modifyMyProfile(profile : ModifyProfileModel, img: Data? = nil, completion: @escaping () -> Void) {
        realProvider.request(.modifyMyProfile(profile: profile, img: img)) { result in
            switch result {
            case let .success(response):
                print(response.description)
                completion()
            case let .failure(error):
                completion()
                print(error.localizedDescription)
            }
        }
    }
    
}

