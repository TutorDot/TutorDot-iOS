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
    @IBOutlet weak var signUpButton: UIButton!
    
    // Constraint outlets
    @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var roleStatus: String = "tutor"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noticeLabel.textColor = UIColor.brownishGrey
        numberLabel.textColor = UIColor.brownishGrey
        print(roleStatus)
    }
    
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextButtonSelected(_ sender: Any) {
        guard let receiveViewController = self.storyboard?.instantiateViewController(withIdentifier: SignUp2VC.identifier) as? SignUp2VC else {return}
        
        self.navigationController?.pushViewController(receiveViewController, animated: true)
    }
    
    
    @IBAction func isTutorSelected(_ sender: Any) {
        isTutorButton.isSelected = true
        isTuteeButton.isSelected = false
        isTutorButton.setImage(UIImage(named: "signupBtnTutorPick"), for: .normal)
        isTuteeButton.setImage(UIImage(named: "signupBtnTuteeUnpick"), for: .normal)
        roleStatus = "tutor"
        
        guard let lastVC = self.storyboard?.instantiateViewController(withIdentifier: SignUp2VC.identifier) as? SignUp2VC else {return}
        lastVC.role = roleStatus
        print(roleStatus)
    }


    @IBAction func isTuteeSelected(_ sender: Any) {
        
        isTutorButton.isSelected = false
        isTuteeButton.isSelected = true
        isTutorButton.setImage(UIImage(named: "signupBtnTutorUnpick"), for: .normal)
        isTuteeButton.setImage(UIImage(named: "signupBtnTuteePick"), for: .normal)
        roleStatus = "tutee"
        
        guard let lastVC = self.storyboard?.instantiateViewController(withIdentifier: SignUp2VC.identifier) as? SignUp2VC else {return}
        lastVC.role = roleStatus
        print(roleStatus)
    }
    
    
}





