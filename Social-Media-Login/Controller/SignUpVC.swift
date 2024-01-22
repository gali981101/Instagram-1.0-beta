//
//  SignUpVC.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/14.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    // MARK: - @IBOutlet
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
}

// MARK: - Life Cycle

extension SignUpVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sign Up"
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        nameTextField.becomeFirstResponder()
        passwordTextField.disableAutoFill()
    }
    
}

// MARK: - Action Methods

extension SignUpVC {
    
    @IBAction func registerAccount(sender: UIButton) {
        
        guard let name = nameTextField.text, !(name.isEmpty),
              let emailAddress = emailTextField.text, !(emailAddress.isEmpty),
              let password = passwordTextField.text, !(password.isEmpty) else {
            
            let alert = makeAlert(message: "Please make sure you provide your name, email address and password to com plete the registration.")
            present(alert, animated: true)
            
            return
        }
        
        createUser(name: name, email: emailAddress, password: password)
    }
    
}

// MARK: - Auth

extension SignUpVC {
    
    private func createUser(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.present(makeAlert(message: error.localizedDescription), animated: true)
                return
            }
            
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = name
                changeRequest.commitChanges { if let error = $0 { print("Change the display name fail: \(error)") } }
            }
            
            self.view.endEditing(true)
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                guard error == nil else { fatalError() }
                
                let alert = UIAlertController(title: "Email Verification", message: "We've just sent a confirmation email to your email address. Please check your inbox and click the verification link in that email to complete the sign up.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                    self.dismiss(animated: true)
                }
                
                alert.addAction(okAction)
                self.present(alert, animated: true)
            })
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension SignUpVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        case emailTextField:
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
}
