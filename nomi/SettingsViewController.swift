//
//  SettingsViewController.swift
//  nomi
//
//  Created by Ivo Silva on 25/11/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var contact_image_ivo: UIImageView!
    @IBOutlet weak var contact_image_daniel: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setNeedsStatusBarAppearanceUpdate()
        
        self.contact_image_ivo.layer.cornerRadius = contact_image_ivo.frame.size.width / 2
        self.contact_image_ivo.clipsToBounds = true
        
        self.contact_image_daniel.layer.cornerRadius = contact_image_daniel.frame.size.width / 2
        self.contact_image_daniel.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        setContactImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    @IBAction func button_logout_click() {
        print("Logout")
        UserInfoModel.sharedInstance.cleanInstance()
        ContactsModel.sharedInstance.cleanInstance()
        UserProfilesModel.sharedInstance.cleanInstance()
    }
    
    func setContactImage() {
        
        contact_image_ivo.layer.cornerRadius = contact_image_ivo.frame.size.width / 2
        contact_image_ivo.clipsToBounds = true
        
        contact_image_daniel.layer.cornerRadius = contact_image_daniel.frame.size.width / 2
        contact_image_daniel.clipsToBounds = true
        
        let email1 = "ivosilva@ua.pt"
        let email2 = "daniel.silva@ua.pt"
        
        let curatedEmail1: String = email1.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString
        let curatedEmail2: String = email2.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString
        
        var result1 = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        var result2 = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        
        if let data1 = curatedEmail1.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data1.bytes, CC_LONG(data1.length), &result1)
        }
        if let data2 = curatedEmail2.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data2.bytes, CC_LONG(data2.length), &result2)
        }
        
        // compute MD5
        let md5email1: String = String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result1[0], result1[1], result1[2], result1[3], result1[4], result1[5], result1[6], result1[7], result1[8], result1[9], result1[10], result1[11], result1[12], result1[13], result1[14], result1[15])
        let md5email2: String = String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", result2[0], result2[1], result2[2], result2[3], result2[4], result2[5], result2[6], result2[7], result2[8], result2[9], result2[10], result2[11], result2[12], result2[13], result2[14], result2[15])
        
        let gravatarEndPoint1: String = "http://www.gravatar.com/avatar/\(md5email1)?s=512"
        let gravatarEndPoint2: String = "http://www.gravatar.com/avatar/\(md5email2)?s=512"
        
        
        let url1 = NSURL(string: gravatarEndPoint1)
        getDataFromUrl(url1!) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download1 Finished")
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionFade
                self.contact_image_ivo.layer.addAnimation(transition, forKey: nil)
                self.contact_image_ivo.image = UIImage(data: data)
                
            }
        }
        
        let url2 = NSURL(string: gravatarEndPoint2)
        getDataFromUrl(url2!) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download2 Finished")
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionFade
                self.contact_image_daniel.layer.addAnimation(transition, forKey: nil)
                self.contact_image_daniel.image = UIImage(data: data)
                
            }
        }
        
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
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
