//
//  PostCell.swift
//  Social Network
//
//  Created by JAY PATEL on 6/2/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var likeImg: CircleImageView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configCell(_ post: Post) {
        if let img = Cache.shared.getImageForKey(post.postKey) {    // load from cache
            postImg.image = img
        } else {    // Download image
            let ref = Storage.storage().reference(forURL: post.imgUrl)
            ref.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Unable to download post image from firebase storage: \(error)")
                } else {
                    if let data = data , let img = UIImage(data: data) {
                        self.postImg.image = img
                        Cache.shared.setImageForKey(post.postKey, andImage: img)
                    }
                }
            }
        }
        caption.text = post.caption
        likesLbl.text = "\(post.likes)"
    }
}
