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

    var post: Post!
    var likesRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped(_:)))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    
    func configCell(_ post: Post) {
        self.post = post
        postImg.image = nil
        likesRef = DataService.shared.REF_CURRENT_USER.child(LIKES).child(post.postKey)
        if let img = Cache.shared.getImageForKey(post.imgUrl) {    // load from cache
            postImg.image = img
        } else {    // Download image
            let ref = Storage.storage().reference(forURL: post.imgUrl)
            ref.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Unable to download post image from firebase storage: \(error)")
                } else {
                    if let data = data , let img = UIImage(data: data) {
                        self.postImg.image = img
                        Cache.shared.setImageForKey(post.imgUrl, andImage: img)
                    }
                }
            }
        }
        caption.text = post.caption
        likesLbl.text = "\(post.likes)"
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    func likeTapped(_ gesture: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.setValue(NSNull())
            }
        })
    }
}
