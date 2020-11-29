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
        //모델이 변경되었다는 것을 뷰 컨드롤러에게 알림
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewClassAddedNotification"), object: nil)
        
        
        // root View 로 이동
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    

    
    @IBAction func checkScheduleDidTap(_ sender: Any) {

        // Calendar Tab으로 이동
        UserDefaults.standard.value(forKey: "token")
        let tabbarStoryboard = UIStoryboard.init(name: "MainTab", bundle: nil)
        guard let mainView = tabbarStoryboard.instantiateViewController(identifier:"TabbarVC") as?
                TabbarVC else { return }
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    
    }
    
}
