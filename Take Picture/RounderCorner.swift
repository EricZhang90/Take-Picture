//
//  RounderCorner.swift
//  Take Picture
//
//  Created by Eric on 2016-11-08.
//  Copyright © 2016 Eric. All rights reserved.
//

import Foundation
import UIKit

protocol RounderCorner {
    var layer: CALayer {get}
}

extension RounderCorner {
    func roundCorner() {
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
}
