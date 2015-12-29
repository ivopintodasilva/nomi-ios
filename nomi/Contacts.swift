//
//  Contacts.swift
//  nomi
//
//  Created by Ivo Silva on 27/12/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import Foundation

class ContactsModel{

    
    static let sharedInstance = ContactsModel()
    
    var user_contacts: [ProfileModel] = []
    
    private init(){}
    
    func get(id: Int) -> ProfileModel?{
        //self.user_contacts.append(profile)
        
        for element in self.user_contacts {
            if(element.id == id){
                return element
            }
        }
        return nil
    }
    
    func addProfile(profile: ProfileModel){
        self.user_contacts.append(profile)
    }

    func size() -> Int{
        return self.user_contacts.count
    }

}