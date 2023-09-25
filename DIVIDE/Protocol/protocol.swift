//
//  ViewControllerProtocol.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/22.
//

import Foundation
import RxSwift

/// 코드 기반 VC 프로토콜
protocol ViewControllerFoundation {
    func setAttribute()
    func addView()
    func setLayout()
    func setUp()
    func addAction()
}

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

/// 회원가입 (회원가입 + 로그인)
protocol SignUpBusinessLogic : DIVIDELoginLogic {
    func requestSignUp(signUpInfo: SignUpModel, imageData : Data, completion: @escaping (Result<SignUpResponse, Error>) -> Void)
    
    func divideSignIn(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void)
}

/// 리뷰 상세화면(리뷰 상세 + 좋아요 + 좋아요 취소)
protocol ReviewDetailBusinessLogic : reviewLikeLogic {
    func requestReviewDetail(reviewId: Int) -> Single<ReviewDetailModel>
    
    func requestReviewLike(reviewId : Int, completion : @escaping (Result<ReviewLikeResponse, Error>) -> Void)
    func requestReviewUnLike(reviewId : Int, completion : @escaping (Result<ReviewUnLikeResponse, Error>) -> Void)
}

/// 리뷰 좋아요 + 좋아요 취소
protocol reviewLikeLogic {
    func requestReviewLike(reviewId : Int, completion : @escaping (Result<ReviewLikeResponse, Error>) -> Void)
    func requestReviewUnLike(reviewId : Int, completion : @escaping (Result<ReviewUnLikeResponse, Error>) -> Void)
}

/// 주변 리뷰 조회 + 리뷰 좋아요 + 좋아요 취소
protocol ReviewBusinessLogic : reviewLikeLogic {
    
    /// 주변 가게의 리뷰 정보 조회
    func requestAroundReviews(param: UserPosition) -> Single<[ReviewData]>
    
    /// 리뷰 좋아요 누르기
    func requestReviewLike(reviewId : Int, completion : @escaping (Result<ReviewLikeResponse, Error>) -> Void)
    func requestReviewUnLike(reviewId : Int, completion : @escaping (Result<ReviewUnLikeResponse, Error>) -> Void)

}

/// 프로필 VC에서 사용
protocol ProfileBusinessLogic {
    /// 주변 가게의 리뷰 정보 조회
    func requestMyProfile() -> Single<ProfileModel>
    /// 프로필 수정 요청
    func modifyMyProfile(profile : ModifyProfileModel, img : Data?, completion: @escaping () -> Void)
    /// 회원 탈퇴
    func withDraw()
}

/// 리뷰 작성
protocol PostReviewBesinessLogic {
    /// 리뷰 작성 데이터 전송
    func postReview(postReviewModel: PostReviewModel, img : [Data], completion: @escaping (Result<PostReviewResponse, Error>) -> Void)
}

/// 디바이더 모집 비즈니스 로직
protocol PostRecruitingBusinessLogic {
    /// 디바이더 모집 요청
    func requestpostRecruiting(param: PostRecruitingInput, img: [Data], completion: @escaping (Result<PostRecruitingResponse, Error>) -> Void)
}

/// 내가 쓴 리뷰
protocol MyReviewBusinessLogic {
    /// 내가 쓴 리뷰 조회
    func requestMyReview(first : Int?) -> Single<[ReviewData]>
}

/// 상세 게시글 진입 후
protocol PostDetailBusinessLogic {
    /// 게시글 상세 정보 조회
    func requestPostDetail(postId : Int) -> Single<PostDetailModel>
    
    /// 게시글에 참여
    func joinOrder(joinOrder : JoinOrderModel, images : [Data], completion: @escaping (Result<JoinOrderResponse, Error>) -> Void)
}
