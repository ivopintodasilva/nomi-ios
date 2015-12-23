//
//  Profile.swift
//  nomi
//
//  Created by Ivo Silva on 23/12/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import Foundation

class ProfileModel{
    
    var id: Int
    var user_id: Int
    var name: String
    var color: String
    var connections: [Int]
    var attributes: [ProfileAttributeModel]
    
    init(id: Int, user_id: Int, name: String, color: String, connections: [Int]) {
        self.id = id
        self.user_id = user_id
        self.name = name
        self.color = color
        self.connections = connections
        self.attributes = []
    }
    
    func addAttribute(attribute: ProfileAttributeModel){
        self.attributes.append(attribute)
    }
    
    
    
}