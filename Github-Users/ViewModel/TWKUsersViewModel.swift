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
    
    private var pageSize: Int = 5
    
    // for gihub apis
    private var lastUserId: Int32 = 0
    
    // for local database
    private var offset: Int = 0
    
    func pullDown(
        completion: @escaping ([TWKUserDO]) -> (),
        otherStatusComplete: @escaping ([TWKUserDO]) -> ()) {
        
        self.lastUserId = 0
        self.offset = 0
        
        if TWKNetworkManager.shared.isConnectedToNetwork() {
            TWKNetworkManager.shared.getUsers(
                lastUserId: self.lastUserId,
                pageSize: 0,
                completion: { result in
                    switch result {
                    case .success(let resultUsers):
                        // convert codable data to display model
                        if let users = resultUsers {
                            self.pageSize = users.count
                            
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
                            // get users note message
                            let userIds = users.map({ $0.id ?? 0})
                            DispatchQueue.main.async {
                                if let managedUsers = TWKDatabaseManager.shared.getUsersByIds(userIds: userIds) as? [User] {
                                    let usersOtherStatus = managedUsers.map(
                                        { user in TWKUserDO(id: user.id,
                                                            username: user.login ?? "",
                                                            avatarUrl: user.avatarUrl ?? "",
                                                            hasNote: user.note != nil,
                                                            hasSeen: user.seen,
                                                            note: user.note?.message)

                                        })
                                    otherStatusComplete(usersOtherStatus)
                                }
                            }

                            self.offset += self.pageSize
                            
                            // determine last user id
                            if let lastUser = resultUsers?.last,
                               let lastUserId = lastUser.id {
                                self.lastUserId = lastUserId
                            }
                            
                            completion(self.users)
                        }
                        
                    case .failure(let error):
                        DebugInfoKey.error.log(info: error.description)
                    }
                    
            })
        }
        
        else {
            TWKDatabaseManager.shared.getUsers(
                offset: self.offset,
                limit: self.pageSize,
                completion: { result in
                    switch result {
                    case .success(let managedUsers):
                        if let managedUsers = managedUsers as? [User] {
                            let usersOtherStatus = managedUsers.map(
                                { user in TWKUserDO(id: user.id,
                                                    username: user.login ?? "",
                                                    avatarUrl: user.avatarUrl ?? "",
                                                    hasNote: user.note != nil,
                                                    hasSeen: user.seen,
                                                    note: user.note?.message)

                                })

                            self.offset += self.pageSize

                            // determine last user id
                            if let lastUser = usersOtherStatus.last {
                                self.lastUserId = lastUser.id
                            }

                            completion(usersOtherStatus)
                        }
                        
                    case .failure(let error):
                        DebugInfoKey.error.log(info: error.description)
                    }
                })
            
        }
    }
    
    func pullUp(
        completion: @escaping ([TWKUserDO]) -> (),
        otherStatusComplete: @escaping ([TWKUserDO]) -> ()) {
        
        if TWKNetworkManager.shared.isConnectedToNetwork() {
            TWKNetworkManager.shared.getUsers(
                lastUserId: self.lastUserId,
                pageSize: self.pageSize,
                completion: { result in
                    switch result {
                    case .success(let resultUsers):
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
                            // get users note message
                            let userIds = users.map({ $0.id ?? 0})
                            DispatchQueue.main.async {
                                if let managedUsers = TWKDatabaseManager.shared.getUsersByIds(userIds: userIds) as? [User] {
                                    let usersOtherStatus = managedUsers.map(
                                        { user in TWKUserDO(id: user.id,
                                                            username: user.login ?? "",
                                                            avatarUrl: user.avatarUrl ?? "",
                                                            hasNote: user.note != nil,
                                                            hasSeen: user.seen,
                                                            note: user.note?.message)
                                            
                                        })
                                    otherStatusComplete(usersOtherStatus)
                                }
                            }
                            
                            self.offset += self.pageSize
                            
                            // determine last user id
                            if let lastUser = resultUsers?.last,
                               let lastUserId = lastUser.id {
                                self.lastUserId = lastUserId
                            }
                            
                            completion(self.users)
                        }
                        
                    case .failure(let error):
                        DebugInfoKey.error.log(info: error.description)
                    }
                    
                })
        
        }
        
        else {
            TWKDatabaseManager.shared.getUsers(
                offset: self.offset,
                limit: self.pageSize,
                completion: { result in
                    switch result {
                    case .success(let managedUsers):
                        if let managedUsers = managedUsers as? [User] {
                            let usersOtherStatus = managedUsers.map(
                                { user in TWKUserDO(id: user.id,
                                                    username: user.login ?? "",
                                                    avatarUrl: user.avatarUrl ?? "",
                                                    hasNote: user.note != nil,
                                                    hasSeen: user.seen,
                                                    note: user.note?.message)

                                })

                            self.offset += self.pageSize

                            // determine last user id
                            if let lastUser = usersOtherStatus.last {
                                self.lastUserId = lastUser.id
                            }

                            completion(usersOtherStatus)
                        }
                        
                    case .failure(let error):
                        DebugInfoKey.error.log(info: error.description)
                    }
                })
        }
        
    }
        
    func getUserProfile(
        username: String,
        completion: @escaping (TWKUserProfileDO) -> ()) {
        
        TWKNetworkManager.shared.getUserProfile(
            username: username,
            completion: { result in
                switch result {
                case .success(let profile):
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
                    
                case .failure(let error):
                    DebugInfoKey.error.log(info: error.description)
                }
            })
    }
}
