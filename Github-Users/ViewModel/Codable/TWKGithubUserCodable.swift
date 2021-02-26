//
//  TWKGithubUserCodable.swift
//  Github-Users
//
//  Created by William S. Rena on 2/26/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation

struct TWKGithubUserCodable: Codable {
    let id: Int32?
    let login: String?
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case login = "login"
        case avatarUrl = "avatar_url"
    }
//
//    init(login: String? = "") {
//        self.login = login
////        self.id = id
////        self.avatarUrl = avatarUrl
//    }
    
    init(from decoder: Decoder) throws {
        let keyedValues = try decoder.container(keyedBy: CodingKeys.self)
        
        self.login = try keyedValues.decodeIfPresent(String.self, forKey: .login)
        self.id = try keyedValues.decodeIfPresent(Int32.self, forKey: .id)
        self.avatarUrl = try keyedValues.decodeIfPresent(String.self, forKey: .avatarUrl)
    }
}
