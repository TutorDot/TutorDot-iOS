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
        // root View 로 이동
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func checkClassListButtonDidTap(_ sender: Any) {
        
    }
    

}
