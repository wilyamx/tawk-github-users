//
//  TWKConstants.swift
//  Github-Users
//
//  Created by William S. Rena on 2/25/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

struct TWKReference {
  static let appDelegate = UIApplication.shared.delegate as! AppDelegate
}

public enum DebugInfoKey: String {
  case database = "[DATABASE]>>"
  case users = "[USERS]>>"
}

public enum TWKScreen {
    case userDetails
   
    public var segueIdentifier: String {
        switch self {
        case .userDetails:
            return "UserDetailsSegue"
        }
    }
}
