//
//  LabelClass.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/07/19.
//

import Foundation
import UIKit
import Then

public enum LabelType {
    /// 호빵체
    ///
    /// mainOrange2, basic, size: 25
    case hopang
    /// 타이틀
    ///
    /// mainOrange1, bold, size: 25
    case title
    case orange
    case Big1
    case Big2
    case Point1
    case Point2
    case Point3
    case Point4
    case Point5
    case Basics1
    case Basics2
    case Basics3
    case Basics4
    case Basics5
    case small0
    case small1
    case small2
    case small3
    case small4
    case warning
    
}

class MainLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
        }
        
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame:CGRect.zero)
    }
    
    // 보조 이니셜라이저
    convenience init(type: LabelType) {
        self.init()
        self.textColor = .gray3
        
        switch type {
        case .hopang:
            self.textColor = .mainOrange2
            self.font = UIFont.SDSamliphopang(.basic, size: 25)
        case .title:
            self.font = UIFont.NotoSansKR(.bold, size: 25)
            self.textColor = .mainOrange1
        case .orange:
            self.textColor = .mainOrange1
            self.font = UIFont.NotoSansKR(.bold, size: 10)
        case .Big1:
            self.font = UIFont.NotoSansKR(.bold, size: 22)
        case .Big2:
            self.font = UIFont.NotoSansKR(.bold, size: 20)
        case .Point1:
            self.font = UIFont.NotoSansKR(.regular, size: 16)
        case .Point2:
            self.font = UIFont.NotoSansKR(.bold, size: 13)
        case .Point3:
            self.font = UIFont.NotoSansKR(.bold, size: 14)
        case .Point4:
            self.font = UIFont.NotoSansKR(.bold, size: 16)
        case .Point5:
            self.font = UIFont.NotoSansKR(.bold, size: 18)
        case .Basics1:
            self.font = UIFont.NotoSansKR(.regular, size: 12)
        case .Basics2:
            self.font = UIFont.NotoSansKR(.medium, size: 12)
        case .Basics3:
            self.font = UIFont.NotoSansKR(.bold, size: 12)
        case .Basics4:
            self.font = UIFont.NotoSansKR(.medium, size: 14)
        case .Basics5:
            self.font = UIFont.NotoSansKR(.bold, size: 15)
        case .small0:
            self.font = UIFont.NotoSansKR(.medium, size: 8)
        case .small1:
            self.font = UIFont.NotoSansKR(.regular, size: 10)
        case .small2:
            self.font = UIFont.NotoSansKR(.medium, size: 10)
        case .small3:
            self.font = UIFont.NotoSansKR(.bold, size: 10)
        case .small4:
            self.font = UIFont.NotoSansKR(.medium, size: 7)
        case .warning:
            self.textColor = .red
            self.font = UIFont.NotoSansKR(.bold, size: 13)
        }
    }
}


