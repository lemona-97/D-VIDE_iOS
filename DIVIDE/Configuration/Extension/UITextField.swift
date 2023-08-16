//
//  UITextField.swift
//  DIVIDE
//
//  Created by 임우섭 on 2022/07/04.
//

import UIKit
import SnapKit

extension UITextField {
    func setPaddingFor(left: CGFloat = 0, right: CGFloat = 0) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always
    }
    
    func addLeftImage(image:UIImage) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftImage.image = image
        
        view.addSubview(leftImage)
        leftImage.center = view.center
        self.leftView = view
        self.leftViewMode = .always
    }
    
    func addRightClearButton(){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        rightButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.deleteText()
        }), for: .touchUpInside)
        view.addSubview(rightButton)
        rightButton.center = view.center
        self.rightView = view
        self.rightViewMode = .always
    }
    
    func deleteRightButton() {
        self.rightView = nil
    }
    
    func setDatePicker(target: Any, selector: Selector) {
        let SCwidth = self.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: SCwidth, height: 216))
        datePicker.datePickerMode = .time
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: SCwidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    func deleteText() {
        self.text = ""
    }
}
