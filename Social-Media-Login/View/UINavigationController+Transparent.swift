//
//  UINavigationController+Transparent.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/14.
//

import UIKit

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = UIColor.white
        
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Rubik-Medium", size: 20)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }
    
}

