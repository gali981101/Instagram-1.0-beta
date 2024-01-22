//
//  UITextField+Placeholder.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/14.
//

import UIKit

extension UITextField: UITextFieldDelegate {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        
        set {
            if let placeholder = self.placeholder {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: newValue!])
            }
        }
    }
    
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
    
}
