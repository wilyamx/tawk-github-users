//
//  TWKGithubOrganizatgionCodable.swift
//  Github-Users
//
//  Created by William S. Rena on 2/27/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation

struct TWKGithubOrganizationCodable: Codable {
    let followers: Int32?
    let following: Int32?
    
    enum CodingKeys: String, CodingKey {
        case followers = "followers"
        case following = "following"
    }
    
    init(from decoder: Decoder) throws {
        let keyedValues = try decoder.container(keyedBy: CodingKeys.self)
        
        self.followers = try keyedValues.decodeIfPresent(Int32.self, forKey: .followers)
        self.following = try keyedValues.decodeIfPresent(Int32.self, forKey: .following)
    }
}
