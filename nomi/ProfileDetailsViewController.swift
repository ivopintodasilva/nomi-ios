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
    
    var sectionHeaderView: UIView?
    
    
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
        
        
//        for var section = 0; section < user_profile_attributes.numberOfSections; section++ {
//            for var row = 0; row < user_profile_attributes.numberOfRowsInSection(section); row++ {
//                
//                let cellPath: NSIndexPath = NSIndexPath(forRow: row, inSection: section)
//                let cell: ProfileDetailsCell = user_profile_attributes.cellForRowAtIndexPath(cellPath) as! ProfileDetailsCell
//                print(cell.value.text)
//                UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes[row].value = cell.value.text!
//                
//            }
//        }

    }

    @IBAction func changeColor(sender: AnyObject) {
        
        if self.current_color == "BLACK" {
            color_view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            //self.sectionHeaderView!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
            self.current_color = "WHITE"
        }
        else if self.current_color == "BLUE" {
            color_view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            //self.sectionHeaderView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            self.current_color = "BLACK"
        }
        else if self.current_color == "GREEN" {
            color_view.backgroundColor = UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1)
            //self.sectionHeaderView!.backgroundColor = UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 0.6)
            self.current_color = "BLUE"
        }
        else if self.current_color == "RED" {
            color_view.backgroundColor = UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1)
            //self.sectionHeaderView!.backgroundColor = UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 0.6)
            self.current_color = "GREEN"
        }
        else if self.current_color == "WHITE" {
            color_view.backgroundColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
            //self.sectionHeaderView!.backgroundColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 0.6)
            self.current_color = "RED"
        }
        
        user_profile_attributes.reloadData()
        
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
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        self.sectionHeaderView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50.0))
        
        let text: UILabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
        
        
        text.text = "Add "
        text.font = UIFont(name: "Avenir", size: 20) // In this use your custom font
        text.textAlignment = NSTextAlignment.Center
        text.center = self.sectionHeaderView!.center
        text.center.x = self.sectionHeaderView!.center.x - 120

        
        
        let facebook_button: UIButton = UIButton(type: .Custom)
        let facebook_icon = FAKMaterialIcons.facebookIconWithSize(20)
        
        let twitter_button: UIButton = UIButton(type: .Custom)
        let twitter_icon = FAKMaterialIcons.twitterIconWithSize(20)
        
        let insta_button: UIButton = UIButton(type: .Custom)
        let insta_icon = FAKMaterialIcons.instagramIconWithSize(20)
        
        let google_button: UIButton = UIButton(type: .Custom)
        let google_icon = FAKMaterialIcons.googlePlusIconWithSize(15)
        
        let email_button: UIButton = UIButton(type: .Custom)
        let email_icon = FAKMaterialIcons.emailIconWithSize(20)
        
        let num_button: UIButton = UIButton(type: .Custom)
        let num_icon = FAKMaterialIcons.phoneIconWithSize(20)
        
        let linkedin_button: UIButton = UIButton(type: .Custom)
        let linkedin_icon = FAKMaterialIcons.linkedinBoxIconWithSize(20)
        
        
        if self.current_color == "BLACK" {
            self.sectionHeaderView!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
            text.textColor = UIColor.blackColor()
            facebook_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor())
            twitter_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor())
            insta_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor())
            google_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor())
            email_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor())
            num_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor())
            linkedin_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor())
        }
        else if self.current_color == "BLUE" {
            self.sectionHeaderView!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
            text.textColor = UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1)
            facebook_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1))
            twitter_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1))
            insta_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1))
            google_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1))
            email_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1))
            num_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1))
            linkedin_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 41/255, green: 128/255.0, blue: 185/255, alpha: 1))
        }
        else if self.current_color == "GREEN" {
            self.sectionHeaderView!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
            text.textColor = UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1)
            facebook_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1))
            twitter_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1))
            insta_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1))
            google_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1))
            email_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1))
            num_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1))
            linkedin_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0/255, green: 150/96, blue: 136/255, alpha: 1))
        }
        else if self.current_color == "RED" {
            self.sectionHeaderView!.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
            text.textColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
            facebook_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1))
            twitter_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1))
            insta_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1))
            google_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1))
            email_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1))
            num_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1))
            linkedin_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1))
        }
        else if self.current_color == "WHITE" {
            self.sectionHeaderView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            text.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            facebook_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
            twitter_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
            insta_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
            google_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
            email_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
            num_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
            linkedin_icon.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
        }
        
        
        
        facebook_button.setAttributedTitle(facebook_icon.attributedString(), forState: .Normal)
        facebook_button.addTarget(self, action: "addFacebook:", forControlEvents: .TouchUpInside)
        facebook_button.frame = CGRectMake(0, 0, 30, 30)
        facebook_button.center = self.sectionHeaderView!.center
        facebook_button.center.x = self.sectionHeaderView!.center.x - 70
        
        twitter_button.setAttributedTitle(twitter_icon.attributedString(), forState: .Normal)
        twitter_button.addTarget(self, action: "addTwitter:", forControlEvents: .TouchUpInside)
        twitter_button.frame = CGRectMake(0, 0, 30, 30)
        twitter_button.center = self.sectionHeaderView!.center
        twitter_button.center.x = self.sectionHeaderView!.center.x - 40
        
        insta_button.setAttributedTitle(insta_icon.attributedString(), forState: .Normal)
        insta_button.addTarget(self, action: "addInsta:", forControlEvents: .TouchUpInside)
        insta_button.frame = CGRectMake(0, 0, 30, 30)
        insta_button.center = self.sectionHeaderView!.center
        insta_button.center.x = self.sectionHeaderView!.center.x - 10
        
        google_button.setAttributedTitle(google_icon.attributedString(), forState: .Normal)
        google_button.addTarget(self, action: "addGoogle:", forControlEvents: .TouchUpInside)
        google_button.frame = CGRectMake(0, 0, 30, 30)
        google_button.center = self.sectionHeaderView!.center
        google_button.center.x = self.sectionHeaderView!.center.x + 20
        
        email_button.setAttributedTitle(email_icon.attributedString(), forState: .Normal)
        email_button.addTarget(self, action: "addEmail:", forControlEvents: .TouchUpInside)
        email_button.frame = CGRectMake(0, 0, 30, 30)
        email_button.center = self.sectionHeaderView!.center
        email_button.center.x = self.sectionHeaderView!.center.x + 50
        
        num_button.setAttributedTitle(num_icon.attributedString(), forState: .Normal)
        num_button.addTarget(self, action: "addNum:", forControlEvents: .TouchUpInside)
        num_button.frame = CGRectMake(0, 0, 30, 30)
        num_button.center = self.sectionHeaderView!.center
        num_button.center.x = self.sectionHeaderView!.center.x + 80
        
        linkedin_button.setAttributedTitle(linkedin_icon.attributedString(), forState: .Normal)
        linkedin_button.addTarget(self, action: "addLinkedin:", forControlEvents: .TouchUpInside)
        linkedin_button.frame = CGRectMake(0, 0, 30, 30)
        linkedin_button.center = self.sectionHeaderView!.center
        linkedin_button.center.x = self.sectionHeaderView!.center.x + 110
        
        
        
        
        
        var existent: [String] = []
        
        for element in UserProfilesModel.sharedInstance.user_profiles[profile_row!].attributes {
            existent.append(element.name)
        }
        
        print (existent)
        
        
        
        
        var exists = false
        
        if existent.contains("FACEBOOK") == false {
            exists = true
            self.sectionHeaderView!.addSubview(facebook_button)
        }
        if existent.contains("TWITTER") == false {
            exists = true
            self.sectionHeaderView!.addSubview(twitter_button)
        }
        if existent.contains("INSTAGRAM") == false {
            exists = true
            self.sectionHeaderView!.addSubview(insta_button)
        }
        if existent.contains("GOOGLE") == false {
            exists = true
            self.sectionHeaderView!.addSubview(google_button)
        }
        if existent.contains("EMAIL") == false {
            exists = true
            self.sectionHeaderView!.addSubview(email_button)
        }
        if existent.contains("NUMBER") == false {
            exists = true
            self.sectionHeaderView!.addSubview(num_button)
        }
        if existent.contains("LINKEDIN") == false {
            exists = true
            self.sectionHeaderView!.addSubview(linkedin_button)
        }
        
        if exists{
            self.sectionHeaderView!.addSubview(text)
        }
        
        return sectionHeaderView
    }
    
    
    func addFacebook(sender: AnyObject) {
        NSLog("add facebook")
    }
    
    func addTwitter(sender: AnyObject) {
        NSLog("add twitter")
    }
    
    func addInsta(sender: AnyObject) {
        NSLog("add insta")
    }
    
    func addGoogle(sender: AnyObject) {
        NSLog("add google")
    }
    
    func addEmail(sender: AnyObject) {
        NSLog("add email")
    }
    
    func addNum(sender: AnyObject) {
        NSLog("add num")
    }
    
    func addLinkedin(sender: AnyObject) {
        NSLog("add linkedin")
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
