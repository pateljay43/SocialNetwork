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
import SwiftKeychainWrapper

class LoginVC: UIViewController {
    @IBOutlet weak var email: LoginTextField!
    @IBOutlet weak var pass: LoginTextField!
    @IBOutlet weak var facebookBtn: LoginButton!
    @IBOutlet weak var loginBtn: LoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookBtn.addTarget(self, action: #selector(facebookBtnTapped(_:)), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(loginBtnTapped(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            self.view.isHidden = true
            print("Found uid in the keychain")
            performSegue(withIdentifier: "FeedVC", sender: nil)
        } else {
            self.view.isHidden = false
        }
    }

    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Unable to authenticate with firebase: \(error)")
            } else {
                print("Successfully authenticated with firebase")
                self.setKeyChainForUser(user)
            }
        }
    }
    
    func facebookBtnTapped(_ sender: UIButton) {
        let loginManager = LoginManager()
        if AccessToken.current == nil {
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
        } else {
            print("Previously authenticated with facebook")
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.authenticationToken)
            self.firebaseAuth(credential)
        }
    }
    
    func loginBtnTapped(_ sender: UIButton) {
        if let email = self.email.text , let pass = self.pass.text {
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("Email authenticated with firebase")
                    self.setKeyChainForUser(user)
                } else {
                    Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error == nil {
                            print("New email authenticated with firebase")
                            self.setKeyChainForUser(user)
                        } else {
                            print("Unable to authenticate email with firebase")
                        }
                    })
                }
            })
        }
    }
    
    func setKeyChainForUser(_ user: User?) {
        if let user = user {
            let isSaved = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
            print("Saved UID to keychain? \(isSaved)")
            performSegue(withIdentifier: "FeedVC", sender: nil)
        }
    }
}

