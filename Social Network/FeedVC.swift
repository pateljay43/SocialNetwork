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
    @IBOutlet weak var logoutBtn: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.isUserInteractionEnabled = true
        logoutBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutTapped(_:))))
    }

    func logoutTapped(_ recognizer: UIGestureRecognizer) {
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
