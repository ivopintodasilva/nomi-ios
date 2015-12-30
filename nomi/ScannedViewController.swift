//
//  ScannedViewController.swift
//  nomi
//
//  Created by Ivo Silva on 30/12/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import UIKit

class ScannedViewController: UIViewController {
    
    var contact_id: Int?

    @IBOutlet weak var scanned_image: UIImageView!
    @IBOutlet weak var scanned_name: UILabel!
    
    var session: NSURLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scanned_image.layer.cornerRadius = scanned_image.frame.size.width / 2
        self.scanned_image.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        print (contact_id!)
        
        session = NSURLSession.sharedSession()
        
        
        
        
        
        
        
        
        
        let requestURL = NSURL(string:"http://192.168.160.56:8000/api/profile/relation/")!
        
        let json: [String: AnyObject] = ["profileId1": 47, "profileId2": contact_id!]
        
        do {
            print ("do")
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            print ("after do")
            print (jsonData)
            var request = NSMutableURLRequest(URL: requestURL)
            request.HTTPMethod = "PUT"
            request.HTTPBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            
            let connect_task = session!.dataTaskWithRequest(request, completionHandler:{(data, response, error) in
                
                
                if let httpResponse = response as? NSHTTPURLResponse{
                    if httpResponse.statusCode == 200 {
                        
                        let url_contacts = NSURL(string: "http://192.168.160.56:8000/api/profile/relation/user/" + String(UserInfoModel.sharedInstance.getId()))
                        print(url_contacts)
                        let task_contacts = self.session!.dataTaskWithURL(url_contacts!, completionHandler: {(data, response, error) in
                            if let httpResponse = response as? NSHTTPURLResponse{
                                if httpResponse.statusCode == 200 {
                                    print("no error")
                                    // check if data is not null
                                    if let _ = data
                                    {
                                        
                                        let json = JSON(data: data!)
                                        
                                        ContactsModel.sharedInstance.user_contacts = []
                                        
                                        for (_ ,subJson):(String, JSON) in json["results"] {
                                            
                                            
                                            var connections: [Int] = []
                                            
                                            for (_ ,subJson1):(String, JSON) in subJson["connections"]{
                                                connections.append(subJson1.intValue)
                                            }
                                            
                                            
                                            var attributes: [ProfileAttributeModel] = []
                                            
                                            for (_ ,subJson1):(String, JSON) in subJson["attributes"]{
                                                attributes.append(ProfileAttributeModel(id: subJson1["id"].intValue, name: subJson1["name"].stringValue, value: subJson1["value"].stringValue))
                                            }
                                            
                                            
                                            var profile: ProfileModel = ProfileModel(id: subJson["id"].intValue, user_id: subJson["user"]["id"].intValue, user_fname: subJson["user"]["first_name"].stringValue, user_lname: subJson["user"]["last_name"].stringValue, user_email: subJson["user"]["email"].stringValue,  name: subJson["name"].stringValue, color: subJson["color"].stringValue, connections:  connections, attributes: attributes)
                                            
                                            
                                            ContactsModel.sharedInstance.addProfile(profile)
                                            
                                            
                                            
                                        }
                                        
                                        dispatch_async(dispatch_get_main_queue(), {
                                            let scanned_contact = ContactsModel.sharedInstance.get(self.contact_id!)
                                            self.setImage(scanned_contact!.user_email)
                                            self.scanned_name.text = scanned_contact!.user_fname + " " + scanned_contact!.user_lname
                                        })
                                        
                                    }
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
            
            connect_task.resume()
            
        }catch _{
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertView()
                alert.title = "Impossible operation"
                alert.message = "Please, try again later"
                alert.addButtonWithTitle("Ok")
                alert.show()
            })
        }
        

        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func setImage(user_email: String) {
        //cell.userImageView.image = nil
        
        let email = user_email
        
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
                self.scanned_image.layer.addAnimation(transition, forKey: nil)
                self.scanned_image.image = UIImage(data: data)
            }
        }
        
        
        
        
        
        
        //cell.userImageView
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
