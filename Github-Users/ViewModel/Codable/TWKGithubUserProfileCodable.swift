//
//  TWKGithubUserProfileCodable.swift
//  Github-Users
//
//  Created by William S. Rena on 2/27/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation

struct TWKGithubUserProfileCodable: Codable {
    let id: Int32?
    let login: String?
    let avatarUrl: String?
    
    let followers: Int32?
    let following: Int32?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case login = "login"
        case avatarUrl = "avatar_url"
        
        case followers = "followers"
        case following = "following"
    }
    
    init(from decoder: Decoder) throws {
        let keyedValues = try decoder.container(keyedBy: CodingKeys.self)
        
        self.login = try keyedValues.decodeIfPresent(String.self, forKey: .login)
        self.id = try keyedValues.decodeIfPresent(Int32.self, forKey: .id)
        self.avatarUrl = try keyedValues.decodeIfPresent(String.self, forKey: .avatarUrl)
        
        self.followers = try keyedValues.decodeIfPresent(Int32.self, forKey: .followers)
        self.following = try keyedValues.decodeIfPresent(Int32.self, forKey: .following)
    }
}
