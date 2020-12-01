//
//  InviteCodeVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/10.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

class InviteCodeVC: UIViewController {

    @IBOutlet weak var inviteCodeView: UIView!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var inputCode: UITextField!
    var invitationCode: String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteCodeView.layer.cornerRadius = 5
        connectButton.layer.cornerRadius = 8
        inputCode.addTarget(self, action: #selector(InviteCodeVC.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.invitationCode = inputCode?.text ?? ""
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    @IBAction func connectedButtonDidTap(_ sender: Any) {
        MypageService.MypageServiceShared.connectInvitaionCode(code: invitationCode) { networkResult in
            switch networkResult {
            case .success:
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MypageConnectSuccessVC") as? MypageConnectSuccessVC else {return}
                self.navigationController?.pushViewController(nextVC, animated: true)
            case .pathErr:
                os_log("PathErr", log: .mypage)
            case .serverErr:
                os_log("ServerErr", log: .mypage)
            case .requestErr(let message):
                guard let message = message as? String else { return }
                let alertViewController = UIAlertController(title: "연결실패", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertViewController.addAction(action)
                self.present(alertViewController, animated: true, completion: nil)
            case .networkFail:
                os_log("networkFail", log: .mypage)
            }
            
        }
        
        
    }
    
}
