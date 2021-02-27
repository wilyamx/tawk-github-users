//
//  TWKUsersViewModel.swift
//  Github-Users
//
//  Created by William S. Rena on 2/25/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation

class TWKUsersViewModel: TWKViewModel {
    private var users = [TWKUserDO]()
    private var lastUserId: Int32 = 1
    
    func pullDown(
        completion: @escaping ([TWKUserDO]) -> (),
        otherStatusComplete: @escaping ([TWKUserDO]) -> ()) {
        self.lastUserId = 1
        
        TWKNetworkManager.shared.getUsers(
            lastUserId: self.lastUserId,
            completion: { resultUsers in
                // convert codable data to display model
                if let users = resultUsers {
                    self.users.removeAll()
                    for user in users {
                        DispatchQueue.main.async {
                            TWKDatabaseManager.shared.userCreateOrUpdate(from: user)
                        }
                        
                        let displayObject = TWKUserDO(id: user.id ?? 0,
                                                      username: user.login ?? "",
                                                      avatarUrl: user.avatarUrl ?? "")
                        self.users.append(displayObject)
                    }
                    
                    // get users note statuses
                    // get users seen statuses
                    let userIds = users.map({ $0.id ?? 0})
                    DispatchQueue.main.async {
                        if let managedUsers = TWKDatabaseManager.shared.getUsersByIds(userIds: userIds) as? [User] {
                            let usersNoteStatus = managedUsers.map(
                                { user in TWKUserDO(id: user.id,
                                                    username: user.login ?? "",
                                                    avatarUrl: user.avatarUrl ?? "",
                                                    hasNote: user.note != nil,
                                                    hasSeen: user.seen)
                                    
                                })
                            otherStatusComplete(usersNoteStatus)
                        }
                    }
                    
                    // determine last user id
                    if let lastUser = resultUsers?.last,
                       let lastUserId = lastUser.id {
                        self.lastUserId = lastUserId
                    }
                    completion(self.users)
                }
                
            })
    
    }
    
    func pullUp(
        completion: @escaping ([TWKUserDO]) -> (),
        otherStatusComplete: @escaping ([TWKUserDO]) -> ()) {
        
        TWKNetworkManager.shared.getUsers(
            lastUserId: self.lastUserId,
            completion: { resultUsers in
                // convert codable data to display model
                if let users = resultUsers {
                    self.users.removeAll()
                    for user in users {
                        DispatchQueue.main.async {
                            TWKDatabaseManager.shared.userCreateOrUpdate(from: user)
                        }
                        
                        let displayObject = TWKUserDO(id: user.id ?? 0,
                                                      username: user.login ?? "",
                                                      avatarUrl: user.avatarUrl ?? "")
                        self.users.append(displayObject)
                    }
                    
                    // get users note statuses
                    // get users seen statuses
                    let userIds = users.map({ $0.id ?? 0})
                    DispatchQueue.main.async {
                        if let managedUsers = TWKDatabaseManager.shared.getUsersByIds(userIds: userIds) as? [User] {
                            let usersNoteStatus = managedUsers.map(
                                { user in TWKUserDO(id: user.id,
                                                    username: user.login ?? "",
                                                    avatarUrl: user.avatarUrl ?? "",
                                                    hasNote: user.note != nil,
                                                    hasSeen: user.seen)
                                    
                                })
                            otherStatusComplete(usersNoteStatus)
                        }
                    }
                    
                    // determine last user id
                    if let lastUser = resultUsers?.last,
                       let lastUserId = lastUser.id {
                        self.lastUserId = lastUserId
                    }
                    completion(self.users)
                }
                
            })
    
    }
}
