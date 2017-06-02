//
//  LoginHeaderView.swift
//  Social Network
//
//  Created by JAY PATEL on 6/1/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class LoginUIView : UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = SHADOW_GRAY.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }

}
