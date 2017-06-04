//
//  Constants.swift
//  Social Network
//
//  Created by JAY PATEL on 6/1/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import FacebookCore

let SHADOW_GRAY = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.62)

let KEY_UID = "UID"

let FB_PERMISSIONS = [ReadPermission.email, ReadPermission.publicProfile]
let FB_PERMISSIONS_STR = [Permission.init(name: "email"), Permission.init(name: "public_profile")]

// LoginVC
let SEGUE_FEEDVC = "FeedVC"

// FeedVC
let POST_CELL = "postCell"
let COMPRESSION: CGFloat = 0.5

//Database child paths
let POSTS = "posts"
let IMAGE_URL = "imageUrl"
let LIKES = "likes"
let CAPTION = "caption"
let USERS = "users"
let PROVIDER = "provider"

// Storage paths
let POST_PICS = "post-pics"
