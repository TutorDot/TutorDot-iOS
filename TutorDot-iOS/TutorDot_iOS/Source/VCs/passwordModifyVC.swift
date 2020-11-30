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
    
    @IBOutlet weak var correctLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ModifyButton.layer.cornerRadius = 8
        correctLabel.isHidden = true
        
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func comparePassword(_ sender: Any) {
        if newpasswordCheckTextField.text == newpasswordTextField.text && newpasswordCheckTextField.text?.length == newpasswordTextField.text?.length{
            correctLabel.isHidden = true
        } else {
            correctLabel.isHidden = false
        }
    }
    
    @IBAction func changePassword(_ sender: Any) {
        guard let inputID = idTextField.text else { return }
        guard let inputPw = newpasswordTextField.text else { return }
        print(inputID, inputPw, "비번")
        
        ProfileService.ProfileServiceShared.changePassword(email: inputID, newPassword: inputPw) { networkResult in switch networkResult {
        case .success(_):
            // 자동로그인이 선택되어 있으면 id,pwd를 공유객체에 저장함
            let alertViewController = UIAlertController(title: "비밀번호 변경 성공", message: "비밀번호가 변경되었습니다", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
        case .requestErr(let message):
            guard let message = message as? String else { return }
            let alertViewController = UIAlertController(title: "비밀번호 변경 실패", message: "아이디 혹은 비밀번호를 확인해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
            print("requestErr")
        case .pathErr:
            let alertViewController = UIAlertController(title: "비밀번호 변경 실패", message: "아이디 혹은 비밀번호를 확인해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
            print("pathErr")
        case .serverErr: print("serverErr")
        case .networkFail: print("networkFail") }
        }
}
}
