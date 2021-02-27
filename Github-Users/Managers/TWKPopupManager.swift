//
//  TWKPopupManager.swift
//  Github-Users
//
//  Created by William S. Rena on 2/27/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import UIKit

class TWKPopupManager {
  static let shared = TWKPopupManager()
  
  public func popUpErrorDetails(
    presenter: UIViewController,
    title: String,
    message: String) {
    
    let okAction = UIAlertAction(
      title: "OK",
      style: .default,
      handler: { (action) -> Void in
         
      })
    
    let dialogMessage = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)
    dialogMessage.addAction(okAction)
    
    presenter.present(dialogMessage, animated: true, completion: nil)
  }
}
