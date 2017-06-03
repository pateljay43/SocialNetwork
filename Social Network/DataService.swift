//
//  DataService.swift
//  Social Network
//
//  Created by JAY PATEL on 6/2/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()   // contains root object url of the firebase DB

class DataService {
    static let shared = DataService()
    
    fileprivate var _REF_BASE = DB_BASE
    fileprivate var _REF_POSTS = DB_BASE.child("posts")
    fileprivate var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference { return _REF_BASE }
    var REF_POSTS: DatabaseReference { return _REF_POSTS }
    var REF_USERS: DatabaseReference { return _REF_USERS }
    
    func createUser(_ uid: String, withData data: Dictionary<String, String>) {
        /**
         * child -> if uid don't exist, it is created
         * updateChildValues -> just updates the mentioned keys (can create new if it don't exist)
         */
        REF_USERS.child(uid).updateChildValues(data)
    }
}
