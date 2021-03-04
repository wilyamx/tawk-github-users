//
//  WSRConstants.swift
//  Github-Users
//
//  Created by William S. Rena on 3/4/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var networkConnectionChanged: Notification.Name {
        return .init(rawValue: "WSRNetworkMonitor.connectionChanged")
    }
}
