//
//  TWKUserProfileDO.swift
//  Github-Users
//
//  Created by William S. Rena on 2/27/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKUserProfileDO: TWKUserDO {
    var followers: Int32
    var following: Int32
    
    var name: String
    var company: String
    var blog: String
    
    init(id: Int32,
         username: String,
         avatarUrl: String,
         followers: Int32,
         following: Int32,
         name: String,
         company: String,
         blog: String) {
        
        self.followers = followers
        self.following = following
        
        self.name = name
        self.company = company
        self.blog = blog
        
        super.init(id: id, username: username, avatarUrl: avatarUrl)
    }
}
