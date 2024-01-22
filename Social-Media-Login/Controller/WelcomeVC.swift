//
//  WelcomeVC.swift
//  Social-Media-Login
//
//  Created by Terry Jason on 2024/1/14.
//

import UIKit

class WelcomeVC: UIViewController {
}

// MARK: - Life Cycle

extension WelcomeVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
    }
    
}

// MARK: - Action Methods

extension WelcomeVC {
    
    @IBAction func unwindtoWelcomeView(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
}
