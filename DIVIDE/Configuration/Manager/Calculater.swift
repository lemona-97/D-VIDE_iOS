//
//  CalculateManager.swift
//  DIVIDE
//
//  Created by wooseob on 2023/07/18.
//

import Foundation


final class Calculater {
    class func setAMPM(closingTime: Int) -> String {
        if (closingTime % 86400) / 3600 >= 12 {
            print((closingTime % 86400) / 3600)
            return "PM"
        } else {
            return "AM"
        }
    }
    
    class func calculatedRemainTime(targetTime : Int) -> String {
        let remainTime = targetTime - Int(Date().timeIntervalSince1970) - 43200 // 12시간 조정..?
        if remainTime > 86400 {
            return "D - 1 이후 주문예정"
        } else if remainTime > 3600 {
            return String(remainTime / 3600) + " 시간 " + String(remainTime % 3600 / 60) + "분 후 주문 예정"
        } else if remainTime > 0 {
            return String(remainTime / 60) + "분 후 주문 예정"
        } else {
            return "주문 시간이 지났습니다"
        }
    }
}
