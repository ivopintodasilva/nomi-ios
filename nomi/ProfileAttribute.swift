//
//  ProfileAttributes.swift
//  nomi
//
//  Created by Ivo Silva on 23/12/15.
//  Copyright © 2015 Ivo Silva. All rights reserved.
//

import Foundation

class ProfileAttributeModel{
    
    var id: Int
    var name: String
    var value: String
    
    init(id: Int, name: String, value: String) {
        self.id = id
        self.name = name
        self.value = value
    }
    
}