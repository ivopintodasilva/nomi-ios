//
//  ViewController.swift
//  nomi
//
//  Created by Ivo Silva on 24/11/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    var activeField: UITextField?
    
    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var content_view: UIView!

    @IBOutlet weak var email_text: UITextField!
    @IBOutlet weak var password_text: UITextField!
    
    var session: NSURLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setNeedsStatusBarAppearanceUpdate()
        email_text.delegate = self
        password_text.delegate = self
        registerForKeyboardNotifications()
        
        session = NSURLSession.sharedSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func button_login_click() {
        let url = NSURL(string: "http://192.168.160.56:8000/api/user/login/?email=" + email_text.text! + "&password=" + password_text.text!)
        let task = session!.dataTaskWithURL(url!) {(data, response, error) in
            
            print(url)
            print(error)
            // check if an error occured
            if error == nil {
                print("no error")
                // check if data is not null
                if let _ = data
                {
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                }
            } else {
                print("error")
                if #available(iOS 8.0, *) {
                    let alertController = UIAlertController(title: "Error", message: "Put your error message here", preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)

                } else {
                    // Fallback on earlier versions
                    let alert_view = UIAlertView()
                    alert_view.title = "Noop"
                    alert_view.message = "Nothing to verify"
                    alert_view.addButtonWithTitle("Click")
                    alert_view.show()

                }
            }
        }
        
        // performSegueWithIdentifier("login", sender: self)
        print("login")
        task.resume()
    }
    
    
    @IBAction func button_register_click() {
        print("register")
    }

    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        scroll_view.scrollEnabled = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        scroll_view.contentInset = contentInsets
        scroll_view.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let _ = activeField
        {
            if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
            {
                scroll_view.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
        
        
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        scroll_view.contentInset = contentInsets
        scroll_view.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        scroll_view.scrollEnabled = false
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        activeField = nil
    }
    
    
    
}

