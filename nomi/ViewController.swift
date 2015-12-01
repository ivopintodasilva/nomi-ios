//
//  ViewController.swift
//  nomi
//
//  Created by Ivo Silva on 24/11/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tf_email.delegate = self
        tf_password.delegate = self
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func b_login() {
        print(tf_email.text)
        print(tf_password.text)
        performSegueWithIdentifier("login", sender: self)
    }
    
    
    @IBAction func b_sender() {
        print("register")
    }
    
    /*  hides keyboard on return-pressed  */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*  hides keyboard on view touch  */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

