//
//  AddClassCompleteVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/26.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class AddClassCompleteVC: UIViewController {

    @IBOutlet weak var classCheckButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
        
    }
    
    func setDefault(){
        classCheckButton.layer.cornerRadius = 8
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "MyPageVC")
        nextVC.modalPresentationStyle = .currentContext
        nextVC.modalTransitionStyle = .crossDissolve
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func checkClassListButtonDidTap(_ sender: Any) {
        
    }
    

}
