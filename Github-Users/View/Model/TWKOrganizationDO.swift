//
//  TWKOrganizationDO.swift
//  Github-Users
//
//  Created by William S. Rena on 2/27/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKOrganizationDO: TWKDisplayObject {
    var followers: Int32
    var following: Int32
    
    init(followers: Int32, following: Int32) {
        self.followers = followers
        self.following = following
    }
}
