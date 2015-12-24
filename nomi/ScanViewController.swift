//
//  ScanViewController.swift
//  nomi
//
//  Created by Ivo Silva on 24/12/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

}
