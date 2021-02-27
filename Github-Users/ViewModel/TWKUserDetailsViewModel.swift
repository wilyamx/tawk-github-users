//
//  TWKUserDetailsViewModel.swift
//  Github-Users
//
//  Created by William S. Rena on 2/26/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKUserDetailsViewModel: TWKViewModel {
    
    func getUserProfile(
        username: String,
        completion: @escaping (TWKUserProfileDO) -> ()) {
        
        TWKNetworkManager.shared.getUserProfile(
            username: username,
            completion: { profile in
                if let profile = profile {
                    let displayObject = TWKUserProfileDO(id: profile.id ?? 0,
                                                         username: profile.login ?? "",
                                                         avatarUrl: profile.avatarUrl ?? "",
                                                         followers: profile.followers ?? 0,
                                                         following: profile.following ?? 0,
                                                         name: profile.name ?? "",
                                                         company: profile.company ?? "",
                                                         blog: profile.blog ?? "")
                    completion(displayObject)
                }
            })
    }
    
    func getNote(
        userId: Int32,
        completion: @escaping (TWKNoteDO) -> ()) {
        
        if let managedUser = TWKDatabaseManager.shared.getUserById(userId: userId),
           let user = managedUser as? User {
            completion(TWKNoteDO(message: user.note?.message ?? ""))
        }
    }
    
    func userCreateOrUpdateNote(
        userId: Int32,
        message: String,
        completion: @escaping (TWKNoteDO) -> ()) {
        
        if let message = TWKDatabaseManager.shared.userCreateOrUpdateNote(
            userId: userId,
            message: message) {
            completion(TWKNoteDO(message: message))
        }
    }
    
    func userSeenProfile(
        userId: Int32,
        completion: @escaping () -> ()) {
        
        TWKDatabaseManager.shared.seenUser(userId: userId)
        completion()
    }
}
