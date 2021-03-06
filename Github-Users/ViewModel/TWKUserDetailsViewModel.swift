//
//  TWKUserDetailsViewModel.swift
//  Github-Users
//
//  Created by William S. Rena on 2/26/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKUserDetailsViewModel: TWKViewModel {
    
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
        
        TWKDatabaseManager.shared.userCreateOrUpdateNote(
            userId: userId,
            message: message,
            completion: { message in
                completion(TWKNoteDO(message: message ?? ""))
            })
    }
    
    func userSeenProfile(
        userId: Int32,
        completion: @escaping () -> ()) {
        
        TWKDatabaseManager.shared.seenUser(userId: userId)
        completion()
    }
}
