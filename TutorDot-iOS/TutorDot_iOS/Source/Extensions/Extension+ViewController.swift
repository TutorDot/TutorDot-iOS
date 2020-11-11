//
//  Extension+ViewController.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/14.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  
  public func setupGestureRecognizerEx() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapEx(_:)))
    view.addGestureRecognizer(tap)
  }
  
  @objc func handleTapEx(_ gesture: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  public func registerForKeyboardNotificationsEx() {
    NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShowEx(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHideEx(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  public func unregisterForKeyboardNotificationsEx() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func keyboardWillShowEx(_ notificatoin: Notification) {
    let duration = notificatoin.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
    let curve = notificatoin.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
    let keyboardSize = (notificatoin.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let height = keyboardSize.height - view.safeAreaInsets.bottom
    
    /*
        애니메이션 처리
    */
  }
  
  @objc func keyboardWillHideEx(_ notificatoin: Notification) {
    
    let duration = notificatoin.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
    let curve = notificatoin.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
    
    /*
        애니메이션 처리
    */
  }
    
    
    func add(_ child: UIViewController) {
        // First, add the view of the child to the view of the parent
        addChild(child)
        
        // Then, add the child to the parent
        view.addSubview(child.view)
        
        // Finally, notify the child that it was moved to a parent
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        // First, notify the child that it’s about to be removed
        willMove(toParent: nil)
        
        // Then, remove the child from its parent
        removeFromParent()
        
        // Finally, remove the child’s view from the parent’s
        view.removeFromSuperview()
    }

}
