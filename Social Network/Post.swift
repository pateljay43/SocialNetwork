//
//  Post.swift
//  Social Network
//
//  Created by JAY PATEL on 6/3/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import Foundation

class Post {
    fileprivate var _caption: String!
    fileprivate var _imgUrl: String!
    fileprivate var _likes: Int!
    fileprivate var _postKey: String!
    
    var caption: String { return _caption ?? "" }
    var imgUrl: String { return _imgUrl ?? "" }
    var likes: Int { return _likes ?? 0 }
    var postKey: String { return _postKey ?? "" }
    
    init(caption: String, imgUrl: String, likes: Int) {
        _caption = caption
        _imgUrl = imgUrl
        _likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, Any>) {
        _postKey = postKey
        
        if let caption = postData[CAPTION] as? String {
            _caption = caption
        }
        if let imgUrl = postData[IMAGE_URL] as? String {
            _imgUrl = imgUrl
        }
        if let likes = postData[LIKES] as? Int {
            _likes = likes
        }
    }
}
