//
//  ProfilesViewController.swift
//  nomi
//
//  Created by Ivo Silva on 25/11/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import UIKit


class ProfilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var new_profile_btn: UIButton!
    @IBOutlet weak var profile_table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        new_profile_btn.backgroundColor = UIColor(red: 0.71, green: 0.23, blue: 0.21, alpha: 1)
        new_profile_btn.layer.cornerRadius = new_profile_btn.frame.size.width / 2
        new_profile_btn.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        
        profile_table.delegate = self
        profile_table.dataSource = self
        
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserProfilesModel.sharedInstance.user_profiles.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
        cell.titleLabel.text = UserProfilesModel.sharedInstance.user_profiles[indexPath.row].name
        return cell
    }
}
