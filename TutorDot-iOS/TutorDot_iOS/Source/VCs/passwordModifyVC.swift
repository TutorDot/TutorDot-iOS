//
//  passwordModifyVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/27.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class passwordModifyVC: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newpasswordTextField: UITextField!
    @IBOutlet weak var newpasswordCheckTextField: UITextField!
    
    @IBOutlet weak var ModifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ModifyButton.layer.cornerRadius = 8
        
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func idDeleteButtonDidTap(_ sender: Any) {
        idTextField.text = ""
    }
    
    @IBAction func passwordDelButtonDidTap(_ sender: Any) {
        passwordTextField.text = ""
    }
    
    @IBAction func newPwDelButtonDidTap(_ sender: Any) {
        newpasswordTextField.text = ""
    }
    
    @IBAction func newPwCheckDelButtonDidTap(_ sender: Any) {
        newpasswordCheckTextField.text = ""
    }
    
}
