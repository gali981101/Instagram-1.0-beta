//
//  UIAlertController.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/19.
//

import UIKit

func makeAlert(title: String = "Registration Error", message: String) -> UIAlertController {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .cancel)
    
    alert.addAction(okAction)
    
    return alert
    
}
