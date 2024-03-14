//
//  LoginVC.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/14.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    // MARK: - @IBOulet
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
}

// MARK: - Life Cycle

extension LoginVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Log In"
        emailTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.title = ""
    }
    
}

// MARK: - Action Methods

extension LoginVC {
    
    @IBAction func login(sender: UIButton) {
        guard let emailAddress = emailTextField.text, !(emailAddress.isEmpty),
        let password = passwordTextField.text, !(password.isEmpty) else {
            
            let alert = makeAlert(title: "Login Error", message: "Both fields must not be blank.")
            present(alert, animated: true)
            
            return
        }
        
        userSignIn(email: emailAddress, password: password)
    }
    
}

// MARK: - Auth

extension LoginVC {
    
    private func userSignIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                let alert = makeAlert(title: "Login Error", message: error.localizedDescription)
                self.present(alert, animated: true)
                return
            }
            
            guard let result = result, result.user.isEmailVerified else {
                let alert = UIAlertController(title: "Login Error", message: "You haven't confirmed your email address yet. We sent you a confirmation email wh en you sign up. Please click the verification link in that email. If you need us t o send the confirmation email again, please tap Resend Email.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Resend email", style: .default) { _ in
                    Auth.auth().currentUser?.sendEmailVerification()
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true)
                
                return
            }
            
            self.view.endEditing(true)
            
            guard let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "Feed") else { fatalError() }
            
            let keyWindow = UIApplication
                .shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .last
            
            keyWindow?.rootViewController = feedVC
            
            self.dismiss(animated: true)
        }
    }
    
    private func sendEmail(result: AuthDataResult?) {
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
}
