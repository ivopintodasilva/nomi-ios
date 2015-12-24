//
//  UserProfiles.swift
//  nomi
//
//  Created by Ivo Silva on 23/12/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import Foundation

class UserProfilesModel{
    
    static let sharedInstance = UserProfilesModel()
    
    var user_profiles: [ProfileModel] = []
    
    private init(){}
    
    func addProfile(profile: ProfileModel){
        self.user_profiles.append(profile)
    }
    
}