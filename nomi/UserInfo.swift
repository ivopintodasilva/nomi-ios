//
//  UserInfo.swift
//  nomi
//
//  Created by Ivo Silva on 23/12/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import Foundation

class UserInfoModel{
    
    static let sharedInstance = UserInfoModel()
    
    var id: Int = -1
    var first_name: String = ""
    var last_name: String = ""

    private init() {}
    
    func setId(id: Int){
        self.id = id
    }
    
    func getId() -> Int{
        return self.id
    }
    
    func setFirstName(first_name: String){
        self.first_name = first_name
    }
    
    func getFirstName() -> String{
        return self.first_name
    }
    
    func setLastName(last_name: String){
        self.last_name = last_name
    }
    
    func getLastName() -> String{
        return self.last_name
    }
    
    func cleanInstance(){
        self.id = -1
        self.first_name = ""
        self.last_name = ""
    }
    
}