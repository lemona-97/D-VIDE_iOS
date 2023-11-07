//
//  MyOrderHistoryViewModel.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/03.
//

import Foundation
import RxSwift
import Moya

protocol MyOrderBusinessLogic {
    func requestMyOrderHistory() -> Single<[OrderHistory]>
    
}

final class MyOrderHistoryViewModel : MyOrderBusinessLogic {
    var realProvider = MoyaProvider<APIService>(plugins: [MoyaInterceptor()])

    func requestMyOrderHistory() -> Single<[OrderHistory]> {
        realProvider.rx.request(.requestMyOrderHistory)
            .filterSuccessfulStatusCodes()
            .map(MyOrderHistoryModel.self)
            .flatMap { orderHistory in
                    .just(orderHistory.data)
            }
    }
    

}































