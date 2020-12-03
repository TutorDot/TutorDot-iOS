//
//  ClassDisconnectionVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/27.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

class ClassDisconnectionVC: UIViewController {

    var classid: Int = 0
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var disconnectionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.cornerRadius = 8
        disconnectionButton.layer.cornerRadius = 8
        print(classid, "수업 연결 해제")
    }
    

    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func conformButtonDidTap(_ sender: Any) {
        // Mark - 수업 연결해제 서버 통신
        MypageService.MypageServiceShared.deleteClassConnection(classId: classid) { networkResult in
            switch networkResult {
            case .success :
                // 수업연결 해제 성공 alert
                let alert = UIAlertController(title: "완료", message: "수업 연결이 해제되었습니다.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {_ in self.navigationController?.popToRootViewController(animated: true)}))
                self.present(alert, animated: true, completion: nil)
                
                os_log("success", log: .mypage)
            case .pathErr :
                os_log("PathErr", log: .mypage)
            case .serverErr :
                os_log("ServerErr", log: .mypage)
            case .requestErr(let message) :
                os_log(message as! StaticString , log: .mypage)
            case .networkFail:
                os_log("networkFail", log: .mypage)
            }
        }
    }
}


