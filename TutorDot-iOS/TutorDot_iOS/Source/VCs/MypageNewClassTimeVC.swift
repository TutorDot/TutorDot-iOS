//
//  MypageNewClassTimeVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/26.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class MypageNewClassTimeVC: UIViewController {

    @IBOutlet weak var completeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
        
    }
    
    func setDefault(){
        completeButton.layer.cornerRadius = 8
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonDidTap(_ sender: Any) {
        //AddClassCompleteVC
        let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "AddClassCompleteVC")
        nextVC.modalPresentationStyle = .currentContext
        nextVC.modalTransitionStyle = .crossDissolve
        present(nextVC, animated: true, completion: nil)
    }
}
