//
//  DIVIDETests.swift
//  DIVIDETests
//
//  Created by wooseob on 2023/07/18.
//

import XCTest
@testable import DIVIDE
@testable import RxSwift
//@testable import RxTest
//@testable import RxNimble
/*
 
 // given
 
 // when
 
 // then
 
 */
final class DIVIDETests: XCTestCase {
    
    var disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    func testRequestAroundPosts() throws {
        // given
        let model = UserPosition(longitude: 127.030767490, latitude: 37.49015482509)
        
        // when
        let result = DIVIDE.HomeViewModel().requestAroundPosts(param: model)
        print("result : ", result)
        // then
        XCTAssertNotNil(result)
    }
    
    func testRequestArountPostsWithCategory() throws {
        // given
        let model = UserPosition(longitude: 127.030767490, latitude: 37.49015482509)
        let category = "KOREAN_FOOD"
        
        // when
        let result = DIVIDE.HomeViewModel().requestAroundPostsWithCategory(param: model, category: category)
        
        // then
        XCTAssertNotNil(result)
    }
    
    func testReverseGeocoding() throws {
        // given
        let latitude = 37.49217651113439
        let longitude = 127.03117309418217
        let answer = "강남구 역삼동"
        var result = ""
        let expectation = XCTestExpectation(description: "ReverseGeocodingTaskExpectation")
        
        // when
        DIVIDE.GeocodingManager.reverseGeocoding(lat: latitude, lng: longitude) { location in
            result = location
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        // then
        XCTAssertEqual(answer, result)
    }
    
    
    func testRequestPostDetail() throws {
        // given
        var result : PostDetailModel?
        let answer = "에베베제"
        let postId = 3054
        let expectation = XCTestExpectation(description: "Request Post Detail Task Expectation")
        let viewModel = DIVIDE.PostDetailViewModel()
        viewModel.requestPostDetail(postId: postId)
            .asObservable()
            .bind(onNext: { postDetailData in
                result = postDetailData
                expectation.fulfill()
            }).disposed(by: self.disposeBag)
        
        // when
        self.wait(for: [expectation], timeout: 5.0)
        
        // then
        XCTAssertEqual(result?.data?.postDetail?.title, answer)
    }
    
   
    
    
//        func testRequestPostDetail() throws {
//            // given
//
//            // when
//
//            // then
//
//        }
    
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
