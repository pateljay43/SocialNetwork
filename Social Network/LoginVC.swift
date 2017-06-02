//
//  ViewController.swift
//  Social Network
//
//  Created by JAY PATEL on 6/1/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase

class LoginVC: UIViewController {
    @IBOutlet weak var facebookBtn: LoginButton!
    @IBOutlet weak var loginBtn: LoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookBtn.addTarget(self, action: #selector(facebookBtnTapped(_:)), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(loginBtnTapped(_:)), for: .touchUpInside)
    }

    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Unable to authenticate with firebase: \(error)")
            } else {
                print("Successfully authenticated with firebase")
            }
        }
    }
    
    func facebookBtnTapped(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login")
            case .success( _, _, let token):
                print("Successfully authenticated with facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func loginBtnTapped(_ sender: UIButton) {
    }
}

