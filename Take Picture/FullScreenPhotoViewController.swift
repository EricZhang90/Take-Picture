//
//  FullScreenPhotoViewController.swift
//  Take Picture
//
//  Created by Eric on 2016-11-08.
//  Copyright © 2016 Eric. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {

    
    @IBOutlet weak var fullScreenPhoto: UIImageView!
    
    var photo: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullScreenPhoto.image = photo
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
