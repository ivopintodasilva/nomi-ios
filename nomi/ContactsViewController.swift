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
    
    let basicCellIdentifier = "ContactCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        contacts_list.delegate = self
        contacts_list.dataSource = self
        self.contacts_list.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        //cell.userImageView
    }
    
    func setTitleForCell(cell:ContactCell, indexPath:NSIndexPath) {
        let item = ContactsModel.sharedInstance.user_contacts[indexPath.row]
        cell.titleLabel.text = item.user_fname + " " + item.user_lname ?? "[No Name]"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
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
