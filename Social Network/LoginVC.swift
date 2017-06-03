//
//  ViewController.swift
//  Social Network
//
//  Created by JAY PATEL on 6/1/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import NotificationCenter
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
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) , AccessToken.current != nil {
            AccessToken.refreshCurrentToken { (_, error) in
                if let error = error {
                    print("Access token refresh failed: \(error)")
                    AccessToken.current = nil
                } else {
                    self.view.isHidden = true
                    print("Found uid in the keychain")
                    self.performSegue(withIdentifier: "FeedVC", sender: nil)
                }
            }
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
                self.setKeyChainForUserId(user!.uid, andProvider: credential.provider)
            }
        }
    }
    
    func facebookBtnTapped(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(FB_PERMISSIONS, viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login")
            case .success(let grantedPermissions, _, let token):
                if grantedPermissions.count == FB_PERMISSIONS.count {
                    print("Successfully authenticated with facebook")
                    let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                    self.firebaseAuth(credential)
                } else {
                    print("Some of the requested permissions were rejected by user")
                }
            }
        }
    }
    
    func loginBtnTapped(_ sender: UIButton) {
        if let email = self.email.text , let pass = self.pass.text {
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("Email authenticated with firebase")
                    self.setKeyChainForUserId(user!.uid, andProvider: user!.providerID)
                } else {
                    Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error == nil {
                            print("New email authenticated with firebase")
                            self.setKeyChainForUserId(user!.uid, andProvider: user!.providerID)
                        } else {
                            print("Unable to authenticate email with firebase")
                        }
                    })
                }
            })
        }
    }
    
    func setKeyChainForUserId(_ uid: String, andProvider provider: String) {
        DataService.shared.createUser(uid, withData: ["provider":provider])
        let isSaved = KeychainWrapper.standard.set(uid, forKey: KEY_UID)
        print("Saved UID to keychain? \(isSaved)")
        performSegue(withIdentifier: "FeedVC", sender: nil)
    }
}

