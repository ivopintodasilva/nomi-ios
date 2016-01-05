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
    
    @IBOutlet weak var name_tf: UITextField!
    @IBOutlet weak var color_view: UIView!

    let cell_identifier = "userProfileCell"
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var user_profile_attributes: UITableView!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        let paintView = UIView(frame: CGRectMake(0, 50, 320, 430))
        paintView.backgroundColor = UIColor.yellowColor()

        
        print (profile_id!)
        
        name_tf.delegate = self
        
        registerForKeyboardNotifications()
        
        user_profile_attributes.delegate = self
        user_profile_attributes.dataSource = self
        
        user_profile_attributes.separatorStyle = UITableViewCellSeparatorStyle.None
        
        user_profile_attributes.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
        name_tf.text = UserProfilesModel.sharedInstance.user_profiles[profile_row!].name
        
        
        if UserProfilesModel.sharedInstance.user_profiles[profile_row!].color == "BLACK" {
            color_view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].color == "BLUE" {
            color_view.backgroundColor = UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].color == "GREEN" {
            color_view.backgroundColor = UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].color == "RED" {
            color_view.backgroundColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
        }
        else if UserProfilesModel.sharedInstance.user_profiles[profile_row!].color == "WHITE" {
            color_view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
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
