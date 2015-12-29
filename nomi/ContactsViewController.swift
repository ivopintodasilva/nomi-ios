//
//  ContactsViewController.swift
//  nomi
//
//  Created by Ivo Silva on 25/11/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contacts_list: UITableView!
    
    var contact_id: Int?
    
    let basicCellIdentifier = "ContactCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        contacts_list.delegate = self
        contacts_list.dataSource = self
        self.contacts_list.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("size")
        print(ContactsModel.sharedInstance.size())
        return ContactsModel.sharedInstance.size()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return basicCellAtIndexPath(indexPath)
    }
    
    func basicCellAtIndexPath(indexPath:NSIndexPath) -> ContactCell {
        let cell = contacts_list.dequeueReusableCellWithIdentifier(basicCellIdentifier) as! ContactCell
        setImageForCell(cell, indexPath: indexPath)
        setTitleForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setImageForCell(cell:ContactCell, indexPath:NSIndexPath) {
        let item = ContactsModel.sharedInstance.user_contacts[indexPath.row]
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width / 2
        cell.userImageView.clipsToBounds = true
        //cell.userImageView.image = nil
        
        let email = ContactsModel.sharedInstance.user_contacts[indexPath.row].user_email
        
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
                cell.userImageView.layer.addAnimation(transition, forKey: nil)
                cell.userImageView.image = UIImage(data: data)
            }
        }
        

        
        
        //cell.userImageView
    }
    
    func setTitleForCell(cell:ContactCell, indexPath:NSIndexPath) {
        let item = ContactsModel.sharedInstance.user_contacts[indexPath.row]
        cell.titleLabel.text = item.user_fname + " " + item.user_lname ?? "[No Name]"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = ContactsModel.sharedInstance.user_contacts[indexPath.row]
        contact_id = item.id
        
        performSegueWithIdentifier("contactdetails", sender: self)
        contacts_list.deselectRowAtIndexPath(indexPath, animated: true)
        

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "contactdetails") {
            let svc = segue.destinationViewController as! ContactDetailsController
            svc.contact_id = self.contact_id
        }
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
