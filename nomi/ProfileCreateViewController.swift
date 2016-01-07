//
//  ProfileCreateViewController.swift
//  nomi
//
//  Created by Silva on 1/3/16.
//  Copyright © 2016 Ivo Silva. All rights reserved.
//

import UIKit

class ProfileCreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var activeField: UITextField?
    
    var profile_info: NSString?
    var contacts_info: NSString?
    
    //@IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var content_view: UIView!
    
    @IBOutlet weak var color_picker: UIPickerView!
    @IBOutlet weak var txtProfileName: UITextField!
    
    
    var selected_color: Int?
    
    var session: NSURLSession?
    
    var spinner: UIActivityIndicatorView?
    
    let colors = [
        "BLACK",
        "BLUE",
        "GREEN",
        "RED",
        "WHITE"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-heavy", size: 18)!]

        
        self.spinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
        
        txtProfileName.delegate = self
        color_picker.dataSource = self
        color_picker.delegate = self
        
        self.selected_color = 0
        
        registerForKeyboardNotifications()
        
        session = NSURLSession.sharedSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCreateProfile_click(sender: AnyObject) {
        
        self.spinner!.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height) / 2.0)

        navigationController!.setNavigationBarHidden(true, animated: true)
        
        
        let profileName = txtProfileName.text
        let color = selected_color
        let id = String(UserInfoModel.sharedInstance.getId())
        
        if profileName == "" {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "Come on, don't fool us!"
            alert.addButtonWithTitle("Ok, I'm sorry")
            alert.show()
            return
        }
        else{
            self.spinner!.color = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
            self.spinner!.startAnimating()
            self.spinner!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
            self.view.addSubview(self.spinner!)
        }
        
        let params: [String: String] = [
            "name" : profileName!,
            "user" : id,
            "color": colors[color!]
        ]
        print(params)
        print("Valid JSON:", NSJSONSerialization.isValidJSONObject(params))
        
        let url = NSURL(string: "http://192.168.160.56:8000/api/profile/user/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        request.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
            
            let task = self.session!.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                
                if let httpResponse = response as? NSHTTPURLResponse{
                    
                    if httpResponse.statusCode == 200 {
                        print("no error creating profile")
                        
                        // Update profiles
                        UserProfilesModel.sharedInstance.cleanInstance()
                        
                        let url = NSURL(string: "http://192.168.160.56:8000/api/profile/user/" + id)
                        
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
                                        
                                        // segue to other view
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.navigationController!.setNavigationBarHidden(false, animated: true)
                                            self.spinner!.removeFromSuperview()
                                            self.performSegueWithIdentifier("tabController", sender: self)
                                        })
                                        
                                    }
                                } else {
                                    print(httpResponse.description)
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.navigationController!.setNavigationBarHidden(false, animated: true)
                                        self.spinner!.removeFromSuperview()
                                        let alert = UIAlertView()
                                        alert.title = "Error"
                                        alert.message = "Something went wrong."
                                        alert.addButtonWithTitle("Ok, I'll try again")
                                        alert.show()
                                    })
                                }
                                
                            }
                        })
                        
                        task_profile.resume()
                        
                        // Everything ok
                        dispatch_async(dispatch_get_main_queue(), {
                            self.navigationController!.setNavigationBarHidden(false, animated: true)
                            self.spinner!.removeFromSuperview()
                            let alert = UIAlertView()
                            alert.title = "Success"
                            alert.message = "New profile created!"
                            alert.addButtonWithTitle("Ok, nice!")
                            alert.show()
                        })
                    } else {
                        print(httpResponse.description)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.navigationController!.setNavigationBarHidden(false, animated: true)
                            self.spinner!.removeFromSuperview()
                            let alert = UIAlertView()
                            alert.title = "Error"
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
    
    
    /** Picker */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // items count
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return colors.count
    }
    
    // item name
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if colors[row] == "BLACK" {
            return "Black"
        }
        else if colors[row] == "BLUE" {
            return "Blue"
        }
        else if colors[row] == "GREEN" {
            return "Green"
        }
        else if colors[row] == "RED" {
            return "Red"
        }
        else if colors[row] == "WHITE" {
            return "White"
        }
        return ""
    }
    
    // after select picker item
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.selected_color = row
        print (colors[row])
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        
        if colors[row] == "BLACK" {
            pickerLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            pickerLabel.textColor = UIColor.whiteColor()
        }
        else if colors[row] == "BLUE" {
            pickerLabel.backgroundColor = UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1)
            pickerLabel.textColor = UIColor.whiteColor()
        }
        else if colors[row] == "GREEN" {
            pickerLabel.backgroundColor = UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1)
            pickerLabel.textColor = UIColor.whiteColor()
        }
        else if colors[row] == "RED" {
            pickerLabel.backgroundColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
            pickerLabel.textColor = UIColor.whiteColor()
        }
        else if colors[row] == "WHITE" {
            pickerLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            pickerLabel.textColor = UIColor.blackColor()
        }
        
        pickerLabel.text = colors[row]
        pickerLabel.font = UIFont(name: "Avenir", size: 17) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
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
//        //Need to calculate keyboard exact size due to Apple suggestions
//        scroll_view.scrollEnabled = true
//        let info : NSDictionary = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
//        
//        scroll_view.contentInset = contentInsets
//        scroll_view.scrollIndicatorInsets = contentInsets
//        
//        var aRect : CGRect = self.view.frame
//        aRect.size.height -= keyboardSize!.height
//        if let _ = activeField
//        {
//            if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
//            {
//                scroll_view.scrollRectToVisible(activeField!.frame, animated: true)
//            }
//        }
        
        
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
//        //Once keyboard disappears, restore original positions
//        let info : NSDictionary = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
//        scroll_view.contentInset = contentInsets
//        scroll_view.scrollIndicatorInsets = contentInsets
//        self.view.endEditing(true)
//        scroll_view.scrollEnabled = false
        
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
