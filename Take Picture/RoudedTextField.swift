//
//  TextFieldPr.swift
//  Take Picture
//
//  Created by Eric on 2016-11-08.
//  Copyright © 2016 Eric. All rights reserved.
//

import UIKit

class RoudedTextField : UITextField, RounderCorner {
    
    convenience init(frame: CGRect, superView: UIView) {
        self.init(frame: frame)
        roundCorner()
        superView.addSubview(self)
    }
}
