//
//  LogoutPopUpVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/09.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class LogoutPopUpVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    @IBAction func logoutButtonDidTap(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Login", bundle: nil)
        let popupVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
