//
//  LoginVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 30/06/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UIGestureRecognizerDelegate {
    static let identifier: String = "SignUpVC"
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var isTutorButton: UIButton!
    @IBOutlet weak var isTuteeButton: UIButton!
    
    // Constraint outlets
    @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var roleStatus = "tutor"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noticeLabel.textColor = UIColor.brownishGrey
        numberLabel.textColor = UIColor.brownishGrey
        print(roleStatus)
        
    }
    
    @objc func printSomeThing(_ notification: Notification) {
        if isTutorButton.isSelected == true {
            roleStatus = "tutor"
        }
    }
    
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextButtonSelected(_ sender: Any) {
        guard let receiveViewController = self.storyboard?.instantiateViewController(withIdentifier: SignUp2VC.identifier) as? SignUp2VC else {return}
        if isTutorButton.isSelected == false && isTuteeButton.isSelected == false {
            let alert = UIAlertController(title: nil, message: "역할을 선택해주세요", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if isTutorButton.isSelected == true {
                receiveViewController.role = "tutor"
            } else {
                receiveViewController.role = "tutee"
            }
            self.navigationController?.pushViewController(receiveViewController, animated: true)
            
        }
        
    }
    
    
    @IBAction func isTutorSelected(_ sender: Any) {
        isTutorButton.isSelected = true
        isTuteeButton.isSelected = false
        isTutorButton.setImage(UIImage(named: "signupBtnTutorPick"), for: .normal)
        isTuteeButton.setImage(UIImage(named: "signupBtnTuteeUnpick"), for: .normal)
        roleStatus = "tutor"
    
    }


    @IBAction func isTuteeSelected(_ sender: Any) {
        
        isTutorButton.isSelected = false
        isTuteeButton.isSelected = true
        isTutorButton.setImage(UIImage(named: "signupBtnTutorUnpick"), for: .normal)
        isTuteeButton.setImage(UIImage(named: "signupBtnTuteePick"), for: .normal)
        roleStatus = "tutee"
    }
    
    
}





