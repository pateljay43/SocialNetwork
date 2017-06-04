//
//  RoundButton.swift
//  Social Network
//
//  Created by JAY PATEL on 6/1/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class LoginButton: UIButton {

    override func awakeFromNib() {
        layer.shadowColor = SHADOW_GRAY.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        imageView?.contentMode = .scaleAspectFit
    }
    
    // frame property is initialized in this function
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 3.0
    }

}
