//
//  CustomButton.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/14.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius: Double = 25.0 {
        didSet {
            layer.cornerRadius = CGFloat(cornerRadius)
            layer.masksToBounds = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
