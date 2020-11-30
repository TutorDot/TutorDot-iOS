//
//  ClassInviteVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/10.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

class ClassInviteVC: UIViewController {

    @IBOutlet weak var inviteCodeView: UIView!
    @IBOutlet weak var inviteCode: UILabel!
    var classId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteCodeView.layer.cornerRadius = 5
        getClassInvitationCode()
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func copyButtonDidTap(_ sender: Any) {
        
        UIPasteboard.general.string = inviteCode.text
        
        let alertViewController = UIAlertController(title: "완료", message: "초대코드를 복사했습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    
    func getClassInvitationCode() {
        MypageService.MypageServiceShared.getInvitaionCode(classId: classId) { networkResult in
            switch networkResult {
            case .success(let resultData):
                os_log("초대코드 가져오기 success!!!", log: .mypage)
                print(resultData)
                guard let data = resultData as? ClassInvitationCode else { print(Error.self)
                    return }
                
//                let data = resultData as? ClassInvitationCode
                
                self.inviteCode.text = data.code
                
            case .pathErr :
                os_log("PathErr-invitationCode", log: .mypage)
            case .serverErr :
                os_log("ServerErr", log: .mypage)
            case .requestErr(let message) :
                print(message)
            case .networkFail:
                os_log("networkFail", log: .mypage)
            }
        }
    }

}
