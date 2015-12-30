//
//  ContactDetailsController.swift
//  nomi
//
//  Created by Ivo Silva on 28/12/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import UIKit

class ContactDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var contact_id: Int?
    
    var contact: ProfileModel?

    @IBOutlet weak var contact_details_image: UIImageView!
    @IBOutlet weak var contact_details_name: UILabel!
    
    @IBOutlet var contact_attributes: UITableView!
    
    let cell_identifier = "ContactDetailsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contact_details_image.layer.cornerRadius = contact_details_image.frame.size.width / 2
        self.contact_details_image.clipsToBounds = true
        
        self.contact_attributes.delegate = self
        self.contact_attributes.dataSource = self
        
        self.contact_attributes.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.contact_attributes.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
        
        if let id: Int = contact_id!{
            contact = ContactsModel.sharedInstance.get(id)
        }
        
        if let contact_retrieved: ProfileModel = contact!{
            setContactImage()
            setAttributes()
            contact_details_name.text = contact_retrieved.user_fname + " " + contact_retrieved.user_lname
            
            
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAttributes() {

        
        if let contact_retrieved: ProfileModel = contact!{
            for attribute in contact_retrieved.attributes {
                print (attribute.name + " - " + attribute.value)
            }
        }
        
    }
    
    
    func setContactImage() {
        contact_details_image.layer.cornerRadius = contact_details_image.frame.size.width / 2
        contact_details_image.clipsToBounds = true
        
        let email = contact!.user_email
        
        let curatedEmail: String = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString
        
        var result = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        
        if let data = curatedEmail.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &result)
        }
        
        // compute MD5
        let md5email: String = String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15])
        
        let gravatarEndPoint: String = "http://www.gravatar.com/avatar/\(md5email)?s=512"
        
        
        
        let url = NSURL(string: gravatarEndPoint)
        getDataFromUrl(url!) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionFade
                self.contact_details_image.layer.addAnimation(transition, forKey: nil)
                self.contact_details_image.image = UIImage(data: data)
        
            }
        }

    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }

    

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contact_retrieved: ProfileModel = contact!{
            return contact_retrieved.attributes.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = contact_attributes.dequeueReusableCellWithIdentifier(cell_identifier) as! ContactDetailsCell
        cell.value.text = contact!.attributes[indexPath.row].value
        
        // Example of how to write an icon into textbox
        
        //var androidIcon: FAKMaterialIcons = FAKMaterialIcons.androidIconWithSize(48)
        //var result: NSMutableAttributedString = androidIcon.attributedString().mutableCopy() as! NSMutableAttributedString
        //result.appendAttributedString(NSMutableAttributedString(string:" - askjdnkajsnd"))
        //contact_details_name.attributedText = result
        
        
        if contact!.attributes[indexPath.row].name == "FACEBOOK"{
            cell.icon.attributedText = FAKMaterialIcons.facebookIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        }
        else if contact!.attributes[indexPath.row].name == "TWITTER"{
            cell.icon.attributedText = FAKMaterialIcons.twitterIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 0/255, green: 172/255, blue: 238/255, alpha: 1)
        }
        else if contact!.attributes[indexPath.row].name == "INSTAGRAM"{
            cell.icon.attributedText = FAKMaterialIcons.instagramIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 18/255, green: 86/255, blue: 136/255, alpha: 1)
        }
        else if contact!.attributes[indexPath.row].name == "GOOGLE"{
            cell.icon.attributedText = FAKMaterialIcons.googlePlusIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 221/255, green: 75/255, blue: 57/255, alpha: 1)
        }
        else if contact!.attributes[indexPath.row].name == "EMAIL"{
            cell.icon.attributedText = FAKMaterialIcons.emailIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 50/255, green: 80/255, blue: 109/255, alpha: 1)
        }
        else if contact!.attributes[indexPath.row].name == "NUMBER"{
            cell.icon.attributedText = FAKMaterialIcons.phoneIconWithSize(30).attributedString()
            cell.icon.textColor = UIColor(red: 0/255, green: 191/255, blue: 143/255, alpha: 1)
        }
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
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
