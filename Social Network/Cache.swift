//
//  Cache.swift
//  Social Network
//
//  Created by JAY PATEL on 6/3/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class Cache {
    static let shared = Cache()
    
    // [imgUrl : postImage]
    fileprivate var _imageCache: Dictionary<String, UIImage>
    
    init() {
        _imageCache = Dictionary()
    }
    
    func setImageForKey(_ key: String, andImage image: UIImage) {
        _imageCache[key] = image
    }
    
    func getImageForKey(_ key: String) -> UIImage? {
        return _imageCache[key]
    }
    
    func containsImageFor(_ key: String) -> Bool {
        return _imageCache[key] != nil
    }
}
