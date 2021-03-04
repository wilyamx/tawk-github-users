//
//  WSRKeyboardObserver.swift
//  Github-Users
//
//  Created by William S. Rena on 3/4/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation
import UIKit

public protocol WSRKeyboardObserverProtocol: NSObjectProtocol {
    func registerForKeyboardObservers()
    func unregisterForKeyboardObservers()
}

extension WSRKeyboardObserverProtocol where Self: UIViewController {

    // https://stackoverflow.com/questions/38980887/protocol-extension-on-an-objc-protocol
    
    public func registerForKeyboardObservers() {
        let defaultCenter = NotificationCenter.default

        var tokenShow: NSObjectProtocol!
        tokenShow = defaultCenter.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil) {
            [weak self] (notification) in
            
            guard self != nil else {
                defaultCenter.removeObserver(tokenShow!)
                return
            }
            self?.keyboardWillShow((notification as NSNotification) as Notification)
        }

        var tokenHide: NSObjectProtocol!
        tokenHide = defaultCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil) {
            [weak self] (notification) in
            
            guard self != nil else {
                defaultCenter.removeObserver(tokenHide!)
                return
            }
            self?.keyboardWillHide((notification as NSNotification) as Notification)
        }
    }

    public func unregisterForKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func keyboardWillShow(_ notification: Notification) {
        print("]>> keyboardWillShow")
        let rect = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        let height = rect.height
//        var insets = UIEdgeInsetsMake(0, 0, height, 0)
//        insets.top = contentInset.top
//        contentInset = insets
//        scrollIndicatorInsets = insets
    }

    public func keyboardWillHide(_ notification: Notification) {
        print("]>> keyboardWillHide")
//        var insets = UIEdgeInsetsMake(0, 0, 0, 0)
//        insets.top = contentInset.top
//        UIView.animate(withDuration: 0.3) {
//            self.contentInset = insets
//            self.scrollIndicatorInsets = insets
//        }
    }

    

}
