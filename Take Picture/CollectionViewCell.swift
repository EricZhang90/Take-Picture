//
//  CollectionViewCell.swift
//  Take Picture
//
//  Created by Eric on 2016-11-08.
//  Copyright © 2016 Eric. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    func add(_ image: UIImage) {
        imageView = UIImageView(frame: contentView.frame)
        imageView.image = image
        contentView.addSubview(imageView)
    }
}
