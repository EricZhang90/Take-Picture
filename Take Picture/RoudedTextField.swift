//
//  TextFieldPr.swift
//  Take Picture
//
//  Created by Eric on 2016-11-08.
//  Copyright © 2016 Eric. All rights reserved.
//

import UIKit

class RoudedTextField : UITextField, RounderCorner {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        roundCorner()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
