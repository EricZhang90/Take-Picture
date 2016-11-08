//
//  LanViewController.swift
//  Take Picture
//
//  Created by Eric on 2016-10-29.
//  Copyright © 2016 Eric. All rights reserved.
//

import UIKit

class LanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    @IBAction func en(_ sender: AnyObject) {
        let userDefault = UserDefaults.standard
        
        userDefault.removeObject(forKey: "AppleLanguages")
        userDefault .set(["en"], forKey: "AppleLanguages")
        
        userDefault.synchronize()

    }
    
    @IBAction func ja(_ sender: AnyObject) {
        let userDefault = UserDefaults.standard
        
        userDefault.removeObject(forKey: "AppleLanguages")
        userDefault .set(["ja"], forKey: "AppleLanguages")
        
        userDefault.synchronize()

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
