//
//  LogoutPopUpVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/09.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class LogoutPopUpVC: UIViewController {

    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        logoutButton.layer.cornerRadius = 8
        
    }
    
    @IBAction func logoutButtonDidTap(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Login", bundle: nil)
        let popupVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
        // 자동로그인 해제
        let dataSave = UserDefaults.standard // UserDefaults.standard 정의
        dataSave.setValue("", forKey: "save_userNm") // save_userNm 키값에 id값 저장
        dataSave.setValue("", forKey: "save_pw")
        dataSave.setValue("", forKey: "token")
        UserDefaults.standard.synchronize() // setValue 실행
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
