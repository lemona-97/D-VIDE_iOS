//
//  ProfileViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/03.
//

import Foundation
import Moya
import RxSwift

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
    
    func withDraw() {
        realProvider.request(.withDraw) { result in
            switch result {
            case .success(_):
                print("회원 탈퇴 완료")
                
            case .failure(_):
                print("회원 탈퇴 실패")
            }
        }
    }
}

