//
//  TWKUsersViewProtocol.swift
//  Github-Users
//
//  Created by William S. Rena on 2/28/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation

protocol TWKUsersViewProtocol {
    func updateSeenStatus(displayObject: TWKUserDO)
    func updateNoteStatus(displayObject: TWKUserDO)
}
