//
//  UILabel.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/07/04.
//

import UIKit

extension UILabel {
    func addAttributedText(text: String, attributedText: String, font: UIFont) {
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.font, value: font, range: (text as NSString).range(of: attributedText))
        self.attributedText = attributedStr
    }
    
    /* 밑줄 추가 */
    func setUnderline(range: NSRange) {
        guard let attributedString = self.mutableAttributedString() else { return }
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        self.attributedText = attributedString
    }
    
    /* AttributedString이 설정되어있지 않으면 생성하여 반환한다. */
    private func mutableAttributedString() -> NSMutableAttributedString? {
        guard let labelText = self.text, let labelFont = self.font else { return nil }
        
        var attributedString: NSMutableAttributedString?
        if let attributedText = self.attributedText {
            attributedString = attributedText.mutableCopy() as? NSMutableAttributedString
        } else {
            attributedString = NSMutableAttributedString(string: labelText,
                                                         attributes: [NSAttributedString.Key.font :labelFont])
        }
        
        return attributedString
    }
    
}
