//
//  FeedVC.swift
//  Social Network
//
//  Created by JAY PATEL on 6/2/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func logoutTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Firebase signout error: \(error.localizedDescription)")
        }
        if KeychainWrapper.standard.removeObject(forKey: KEY_UID) {
            if let vc = self.presentingViewController , vc is LoginVC {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
