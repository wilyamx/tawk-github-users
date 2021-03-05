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
    var activeTextInput: UITextInput? { get set }
    
    func registerForKeyboardObservers()
    func unregisterForKeyboardObservers()
}

extension WSRKeyboardObserverProtocol where Self: UIViewController {

    // https://stackoverflow.com/questions/38980887/protocol-extension-on-an-objc-protocol
    
    public func registerForKeyboardObservers() {
        let defaultCenter = NotificationCenter.default

        var tokenShow: NSObjectProtocol!
        tokenShow = defaultCenter.addObserver(
            forName: UIResponder.keyboardDidShowNotification,
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
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        guard let uiTextInput = self.activeTextInput as? UIView else {
            return
        }
        
        var shouldMoveViewUp = false

        let bottomOfTextField = uiTextInput.convert(uiTextInput.bounds, to: self.view).maxY;
        let topOfKeyboard = self.view.frame.height - keyboardSize.height

        if bottomOfTextField > topOfKeyboard {
            shouldMoveViewUp = true
        }
        
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height + uiTextInput.bounds.size.height
        }
    }

    public func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }

}
