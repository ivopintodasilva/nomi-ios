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
    
    var login_info: NSString?
    var profile_info: NSString?
    var contacts_info: NSString?
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "login") {
            let tab = segue.destinationViewController as! UITabBarController
            let svc = tab.viewControllers![0] as! ShareViewController
            svc.login_info = self.login_info
            svc.profile_info = self.profile_info
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func button_login_click() {
        let url = NSURL(string: "http://192.168.160.56:8000/api/user/login/?email=" + email_text.text! + "&password=" + password_text.text!)
        let task = session!.dataTaskWithURL(url!, completionHandler: {(data, response, error) in
            
            if let httpResponse = response as? NSHTTPURLResponse{
                
                print (httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    print("no error")
                    // check if data is not null
                    if let _ = data
                    {
                        //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                        self.login_info = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        
                        let data = self.login_info!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                        
                        
                        do {
                            if let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                                
                                
                                if let id = json["id"]{
                                    UserInfoModel.sharedInstance.setId(Int(id.intValue))
                                }
                                
                                if let first_name = json["first_name"]{
                                    UserInfoModel.sharedInstance.setFirstName(first_name as! String)
                                }
                                
                                if let last_name = json["last_name"]{
                                    UserInfoModel.sharedInstance.setLastName(last_name as! String)
                                }
                                
                                
                                
                                
                                let url = NSURL(string: "http://192.168.160.56:8000/api/profile/user/" + String(UserInfoModel.sharedInstance.getId()))
                                print(url)
                                let task_profile = self.session!.dataTaskWithURL(url!, completionHandler: {(data, response, error) in
                                    if let httpResponse = response as? NSHTTPURLResponse{
                                        if httpResponse.statusCode == 200 {
                                            print("no error")
                                            // check if data is not null
                                            if let _ = data
                                            {
                                                self.profile_info = NSString(data: data!, encoding: NSUTF8StringEncoding)

                                                let json = JSON(data: data!)

                                                for (_ ,subJson):(String, JSON) in json["results"] {
                                                    
                                                    
                                                    var connections: [Int] = []
                                                    
                                                    for (_ ,subJson1):(String, JSON) in subJson["connections"]{
                                                        connections.append(subJson1.intValue)
                                                    }
                                                    
                                                    
                                                    var attributes: [ProfileAttributeModel] = []
                                                    
                                                    for (_ ,subJson1):(String, JSON) in subJson["attributes"]{
                                                        attributes.append(ProfileAttributeModel(id: subJson1["id"].intValue, name: subJson1["name"].stringValue, value: subJson1["value"].stringValue))
                                                    }

                                                    
                                                    let profile: ProfileModel = ProfileModel(id: subJson["id"].intValue, user_id: subJson["user"]["id"].intValue, user_fname: subJson["user"]["first_name"].stringValue, user_lname: subJson["user"]["last_name"].stringValue, user_email: subJson["user"]["email"].stringValue,  name: subJson["name"].stringValue, color: subJson["color"].stringValue, connections:  connections, attributes: attributes)
                                                    
                                                    
                                                    UserProfilesModel.sharedInstance.addProfile(profile)
                                                }
                                                
                                                
                                                let url_contacts = NSURL(string: "http://192.168.160.56:8000/api/profile/relation/user/" + String(UserInfoModel.sharedInstance.getId()))
                                                print(url_contacts)
                                                let task_contacts = self.session!.dataTaskWithURL(url_contacts!, completionHandler: {(data, response, error) in
                                                    if let httpResponse = response as? NSHTTPURLResponse{
                                                        if httpResponse.statusCode == 200 {
                                                            print("no error")
                                                            // check if data is not null
                                                            if let _ = data
                                                            {
                                                                self.contacts_info = NSString(data: data!, encoding: NSUTF8StringEncoding)
                                                                
                                                                let json = JSON(data: data!)
                                                                
                                                                for (_ ,subJson):(String, JSON) in json["results"] {
                                                                    
                                                                    
                                                                    var connections: [Int] = []
                                                                    
                                                                    for (_ ,subJson1):(String, JSON) in subJson["connections"]{
                                                                        connections.append(subJson1.intValue)
                                                                    }
                                                                    
                                                                    
                                                                    var attributes: [ProfileAttributeModel] = []
                                                                    
                                                                    for (_ ,subJson1):(String, JSON) in subJson["attributes"]{
                                                                        attributes.append(ProfileAttributeModel(id: subJson1["id"].intValue, name: subJson1["name"].stringValue, value: subJson1["value"].stringValue))
                                                                    }
                                                                    
                                                                    
                                                                    let profile: ProfileModel = ProfileModel(id: subJson["id"].intValue, user_id: subJson["user"]["id"].intValue, user_fname: subJson["user"]["first_name"].stringValue, user_lname: subJson["user"]["last_name"].stringValue, user_email: subJson["user"]["email"].stringValue,  name: subJson["name"].stringValue, color: subJson["color"].stringValue, connections:  connections, attributes: attributes)
                                                                    
                                                                    
                                                                    ContactsModel.sharedInstance.addProfile(profile)
                                                                }
                                                                
                                                                
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), {
                                                                    self.performSegueWithIdentifier("login", sender: self)
                                                                })
                                                            }
                                                        } else {
                                                            dispatch_async(dispatch_get_main_queue(), {
                                                                let alert = UIAlertView()
                                                                alert.title = "Login failed"
                                                                alert.message = "Come on, don't fool us!"
                                                                alert.addButtonWithTitle("Ok, I'm sorry")
                                                                alert.show()
                                                            })
                                                        }
                                                        
                                                    }
                                                })
                                                task_contacts.resume()
                                                
                                                
//                                                dispatch_async(dispatch_get_main_queue(), {
//                                                    self.performSegueWithIdentifier("login", sender: self)
//                                                })
                                            }
                                        } else {
                                            dispatch_async(dispatch_get_main_queue(), {
                                                let alert = UIAlertView()
                                                alert.title = "Login failed"
                                                alert.message = "Come on, don't fool us!"
                                                alert.addButtonWithTitle("Ok, I'm sorry")
                                                alert.show()
                                            })
                                        }
                                        
                                    }
                                })
                                
                                task_profile.resume()
                                
                                
                            }
                            
                            
                        } catch let error as NSError {
                            print("Failed to load: \(error.localizedDescription)")
                        }

                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = UIAlertView()
                        alert.title = "Login failed"
                        alert.message = "Come on, don't fool us!"
                        alert.addButtonWithTitle("Ok, I'm sorry")
                        alert.show()
                    })
                }
                
            }
        })
        
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

