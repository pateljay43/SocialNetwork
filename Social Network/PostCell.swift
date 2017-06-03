//
//  PostCell.swift
//  Social Network
//
//  Created by JAY PATEL on 6/2/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

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
        caption.text = post.caption
        likesLbl.text = "\(post.likes)"
    }
    
}
