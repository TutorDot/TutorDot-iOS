//
//  ClassDisconnectionVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/27.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class ClassDisconnectionVC: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var disconnectionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.cornerRadius = 8
        disconnectionButton.layer.cornerRadius = 8
        
       
    }
    

    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
