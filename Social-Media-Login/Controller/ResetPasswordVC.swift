//
//  ResetPasswordVC.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/14.
//

import UIKit
import Firebase

class ResetPasswordVC: UIViewController {
    
    // MARK: - @IBOulet
    
    @IBOutlet var emailTextField: UITextField!
    
}

// MARK: - Life Cycle

extension ResetPasswordVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Forgot Password"
        emailTextField.becomeFirstResponder()
    }
    
}

// MARK: - Action Methods

extension ResetPasswordVC {
    
    @IBAction func resetPassword(sender: UIButton) {
        guard let emailAddress = emailTextField.text, !(emailAddress.isEmpty) else {
            let alert = makeAlert(title: "Input Error", message: "Please provide your email address for password reset.")
            present(alert, animated: true)
            return
        }
        
        resetUserPassword(email: emailAddress)
    }
    
}

// MARK: - Auth

extension ResetPasswordVC {
    
    private func resetUserPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            let title = (error == nil) ? "Password Reset Follow-up" : "Password Reset Error"
            let message = (error == nil) ? "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password." : error?.localizedDescription
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                if error == nil {
                    self.view.endEditing(true)
                    
                    guard let navController = self.navigationController else { return }
                    navController.popViewController(animated: true)
                }
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
        }
    }
    
}
