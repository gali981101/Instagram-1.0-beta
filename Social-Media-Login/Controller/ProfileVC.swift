//
//  ProfileVC.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/14.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    // MARK: - @IBOulet
    
    @IBOutlet var nameLabel: UILabel!
}

// MARK: - Life Cycle

extension ProfileVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Profile"
        
        if let currentUser = Auth.auth().currentUser {
            nameLabel.text = currentUser.displayName
        }
    }
    
}

// MARK: - Action Methods

extension ProfileVC {
    
    @IBAction func close(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logout(sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            let alert = makeAlert(title: "Log Out Error", message: error.localizedDescription)
            present(alert, animated: true)
        }
        
        guard let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "Welcome") else { fatalError() }
        
        let keyWindow = UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
        
        keyWindow?.rootViewController = welcomeVC
        
        self.dismiss(animated: true)
    }
    
}
