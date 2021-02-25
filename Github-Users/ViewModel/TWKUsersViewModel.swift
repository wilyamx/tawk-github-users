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
  
    func getUsers(completion: @escaping ([TWKUserDO]) -> Void) {
        self.users.removeAll()
        self.users.append(TWKUserDO(username: "User 1"))
        self.users.append(TWKUserDO(username: "User 2"))
        self.users.append(TWKUserDO(username: "User 3"))
        self.users.append(TWKUserDO(username: "User 4"))
        completion(self.users)
    }
}
