//
//  LoginTextField.swift
//  Social Network
//
//  Created by JAY PATEL on 6/1/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {
    
    // only applies while not editing text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
    }
    
    // also insets text while editing this text filed
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
    }

}
