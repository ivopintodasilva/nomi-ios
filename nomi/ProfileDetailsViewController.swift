//
//  ProfileDetailsViewController.swift
//  nomi
//
//  Created by Ivo Silva on 04/01/16.
//  Copyright © 2016 Ivo Silva. All rights reserved.
//

import UIKit

class ProfileDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var profile_id: Int?
    var profile_row: Int?
    var activeField: UITextField?
    
    let cell_identifier = "userProfileCell"
    var current_color: String?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var user_profile_attributes: UITableView!
    @IBOutlet weak var name_tf: UITextField!
    @IBOutlet weak var color_view: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name_tf.delegate = self
        user_profile_attributes.delegate = self
        user_profile_attributes.dataSource = self
        
        registerForKeyboardNotifications()
        
        user_profile_attributes.separatorStyle = UITableViewCellSeparatorStyle.None
        user_profile_attributes.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
        name_tf.text = UserProfilesModel.sharedInstance.user_profiles[profile_row!].name
        
        
        if UserProfilesModel.sharedInstance.user_profiles[profile_row!].color == "BLACK" {
            color_view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            self.current_color = "BLACK"
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].color == "BLUE" {
            color_view.backgroundColor = UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1)
            self.current_color = "BLUE"
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].color == "GREEN" {
            color_view.backgroundColor = UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1)
            self.current_color = "GREEN"
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].color == "RED" {
            color_view.backgroundColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
            self.current_color = "RED"
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].color == "WHITE" {
            color_view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            self.current_color = "WHITE"
        }
        
        
    }
    
    
    @IBAction func save(sender: AnyObject) {
        
        
        
        let session = NSURLSession.sharedSession()
        
        let requestURL = NSURL(string:"http://192.168.160.56:8000/api/profile/" + String(self.profile_id!))!
        
        let json: [String: AnyObject] = ["name": name_tf.text!, "color": current_color!]
        
        do {
            print ("do")
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            print ("after do")
            print (jsonData)
            let request = NSMutableURLRequest(URL: requestURL)
            request.HTTPMethod = "PUT"
            request.HTTPBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            
            let edit_profile_task = session.dataTaskWithRequest(request, completionHandler:{(data, response, error) in
                
                
                if let httpResponse = response as? NSHTTPURLResponse{
                    if httpResponse.statusCode == 200 {
                        
                        let url_contacts = NSURL(string: "http://192.168.160.56:8000/api/profile/relation/user/" + String(UserInfoModel.sharedInstance.getId()))
                        print(url_contacts)
                        let task_contacts = session.dataTaskWithURL(url_contacts!, completionHandler: {(data, response, error) in
                            if let httpResponse = response as? NSHTTPURLResponse{
                                if httpResponse.statusCode == 200 {
                                    print("no error")
                                    // check if data is not null
                                    
                                        
                                    dispatch_async(dispatch_get_main_queue(), {
                                        print(self.name_tf.text)
                                        UserProfilesModel.sharedInstance.user_profiles[self.profile_row!].name = self.name_tf.text!
                                        
                                        print(self.current_color)
                                        UserProfilesModel.sharedInstance.user_profiles[self.profile_row!].color = self.current_color!
                                    })
                                        
                                    
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        let alert = UIAlertView()
                                        alert.title = "Impossible operation"
                                        alert.message = "Please, try again later"
                                        alert.addButtonWithTitle("Ok")
                                        alert.show()
                                    })
                                }
                                
                            }
                        })
                        task_contacts.resume()
                        
                    }
                }
                
            })
            
            edit_profile_task.resume()
            
        }catch _{
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertView()
                alert.title = "Impossible operation"
                alert.message = "Please, try again later"
                alert.addButtonWithTitle("Ok")
                alert.show()
            })
        }
        
        
        for var section = 0; section < user_profile_attributes.numberOfSections; section++ {
            for var row = 0; row < user_profile_attributes.numberOfRowsInSection(section); row++ {
                
                
                let cellPath: NSIndexPath = NSIndexPath(forRow: row, inSection: section)
                let cell: ProfileDetailsCell = user_profile_attributes.cellForRowAtIndexPath(cellPath) as! ProfileDetailsCell
                print(cell.value.text)
                UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes[row].value = cell.value.text!
                
            }
        }

    }

    @IBAction func changeColor(sender: AnyObject) {
        
        if self.current_color == "BLACK" {
            color_view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            self.current_color = "WHITE"
        }
        else if self.current_color == "BLUE" {
            color_view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            self.current_color = "BLACK"
        }
        else if self.current_color == "GREEN" {
            color_view.backgroundColor = UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1)
            self.current_color = "BLUE"
        }
        else if self.current_color == "RED" {
            color_view.backgroundColor = UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1)
            self.current_color = "GREEN"
        }
        else if self.current_color == "WHITE" {
            color_view.backgroundColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
            self.current_color = "RED"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.user_profile_attributes.dequeueReusableCellWithIdentifier(cell_identifier) as! ProfileDetailsCell
        
        cell.value.delegate = self
        
        print (UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes[indexPath.row].value)
        cell.value.text = UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes[indexPath.row].value
        
        // Example of how to write an icon into textbox
        
        //var androidIcon: FAKMaterialIcons = FAKMaterialIcons.androidIconWithSize(48)
        //var result: NSMutableAttributedString = androidIcon.attributedString().mutableCopy() as! NSMutableAttributedString
        //result.appendAttributedString(NSMutableAttributedString(string:" - askjdnkajsnd"))
        //contact_details_name.attributedText = result
        
        
        if UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes[indexPath.row].name == "FACEBOOK"{
            cell.icon.attributedText = FAKMaterialIcons.facebookIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes[indexPath.row].name == "TWITTER"{
            cell.icon.attributedText = FAKMaterialIcons.twitterIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 0/255, green: 172/255, blue: 238/255, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes[indexPath.row].name == "INSTAGRAM"{
            cell.icon.attributedText = FAKMaterialIcons.instagramIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 18/255, green: 86/255, blue: 136/255, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes[indexPath.row].name == "GOOGLE"{
            cell.icon.attributedText = FAKMaterialIcons.googlePlusIconWithSize(25).attributedString()
            cell.icon.textColor = UIColor(red: 221/255, green: 75/255, blue: 57/255, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes[indexPath.row].name == "EMAIL"{
            cell.icon.attributedText = FAKMaterialIcons.emailIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 50/255, green: 80/255, blue: 109/255, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes[indexPath.row].name == "NUMBER"{
            cell.icon.attributedText = FAKMaterialIcons.phoneIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 0/255, green: 191/255, blue: 143/255, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes[indexPath.row].name == "LINKEDIN"{
            cell.icon.attributedText = FAKMaterialIcons.linkedinBoxIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 0/255, green: 123/255, blue: 182/255, alpha: 1)
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        user_profile_attributes.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
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
        scrollView.scrollEnabled = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let _ = activeField
        {
            
            print("active field: ")
            print(activeField!)
            
            if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
            {
                scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        scrollView.scrollEnabled = false
        
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
