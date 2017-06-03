//
//  CircleImageView.swift
//  Social Network
//
//  Created by JAY PATEL on 6/2/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = SHADOW_GRAY.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
