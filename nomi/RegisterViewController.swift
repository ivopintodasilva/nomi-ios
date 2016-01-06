//
//  RegisterViewController.swift
//  nomi
//
//  Created by Ivo Silva on 25/11/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import UIKit
//import SwiftHTTP

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    var activeField: UITextField?

    @IBOutlet weak var nav_back: UINavigationItem!
    
    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var content_view: UIView!
    
    @IBOutlet weak var tf_fname: UITextField!
    @IBOutlet weak var tf_lname: UITextField!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var tf_confirmpassword: UITextField!
    
    var session: NSURLSession?
    
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view.
        
        self.spinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - UIApplication.sharedApplication().statusBarFrame.size.height))
        

        
        tf_fname.delegate = self
        tf_lname.delegate = self
        tf_email.delegate = self
        tf_password.delegate = self
        tf_confirmpassword.delegate = self
        registerForKeyboardNotifications()
        
        session = NSURLSession.sharedSession()
    }
    
    
    @IBAction func btn_register() {
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.size.height
        self.spinner!.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height - navigationBarHeight) / 2.0)
        self.spinner!.color = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
        self.spinner!.startAnimating()
        self.spinner!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        self.view.addSubview(self.spinner!)
        
        
        print("registering!")
        // {}
        
        let email = self.tf_email.text
        let password = self.tf_password.text
        let password2 = self.tf_confirmpassword.text
        let fname = self.tf_fname.text
        let lname = self.tf_lname.text
        
        let params: [String: String] = [
            "email" : email!,
            "password" : password!,
            "first_name" : fname!,
            "last_name" : lname!
        ]
        print(params)
        print("Valid JSON:", NSJSONSerialization.isValidJSONObject(params))
        
        if password != password2 {
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner!.removeFromSuperview()
                let alert = UIAlertView()
                alert.title = "Register failed"
                alert.message = "Passwords did not match!"
                alert.addButtonWithTitle("Ok, I'll try again")
                alert.show()
            })
            return
        }
        
        let url = NSURL(string: "http://192.168.160.56:8000/api/user/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        request.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
            
            let task = self.session!.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
                if let httpResponse = response as? NSHTTPURLResponse{
                    
                    if httpResponse.statusCode == 200 {
                        print("no error registering")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner!.removeFromSuperview()
                            let alert = UIAlertView()
                            alert.title = "Register success"
                            alert.message = "Congratulations, you'r registered!"
                            alert.addButtonWithTitle("Ok, lets go do login")
                            alert.show()
                            
                            self.performSegueWithIdentifier("register", sender: self)
                        })
                    } else {
                        print(httpResponse.description)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner!.removeFromSuperview()
                            let alert = UIAlertView()
                            alert.title = "Register failed"
                            alert.message = "Something went wrong."
                            alert.addButtonWithTitle("Ok, I'll try again")
                            alert.show()
                        })
                    }
                }
            })
            
            task.resume()
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    /*  hides keyboard on return-pressed  */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
