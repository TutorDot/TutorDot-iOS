//
//  MypageNewClassDetailVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/26.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class MypageNewClassDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        //MyClassAddTimeVC
        let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "MyClassAddTimeVC")
        nextVC.modalPresentationStyle = .currentContext
        nextVC.modalTransitionStyle = .crossDissolve
        present(nextVC, animated: true, completion: nil)
    }
    

}
