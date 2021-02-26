//
//  TWKUserDO.swift
//  Github-Users
//
//  Created by William S. Rena on 2/25/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKUserDO: TWKDisplayObject {
    
    var id: Int32
    var username: String
    var avatarUrl: String
    
    init(id: Int32,
         username: String,
         avatarUrl: String) {
        self.id = id
        self.username = username
        self.avatarUrl = avatarUrl
    }
}
