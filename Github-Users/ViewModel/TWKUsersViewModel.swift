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
    
    func getUsers(completion: @escaping ([TWKUserDO]) -> ()) {
        TWKNetworkManager.shared.getUsers(
            lastUserId: self.lastUserId,
            completion: { resultUsers in
                // convert codable data to display model
                if let users = resultUsers {
                    self.users.removeAll()
                    for user in users {
                        self.users.append(TWKUserDO(username: user.login ?? ""))
                    }
                }
                // determine last user id
                if let lastUser = resultUsers?.last,
                   let lastUserId = lastUser.id {
                    self.lastUserId = lastUserId
                }
                completion(self.users)
            })
    
    }
    
}
