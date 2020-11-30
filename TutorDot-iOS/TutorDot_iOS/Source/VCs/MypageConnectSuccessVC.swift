//
//  MypageConnectSuccessVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/30.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class MypageConnectSuccessVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 8

    }
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func serviceStartButtonDidTap(_ sender: Any) {
        // 로그인 성공시 뷰 전환
        let tabbarStoryboard = UIStoryboard.init(name: "MainTab", bundle: nil)
        guard let mainView = tabbarStoryboard.instantiateViewController(identifier:"TabbarVC") as?
                TabbarVC else { return }
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    
}
