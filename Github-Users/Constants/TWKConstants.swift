//
//  TWKConstants.swift
//  Github-Users
//
//  Created by William S. Rena on 2/25/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

struct LIGReference {
  static let appDelegate = UIApplication.shared.delegate as! AppDelegate
}

public enum DebugInfoKey: String {
  case database = "[DATABASE]>>"
  case messaging = "[USERS]>>"
}
