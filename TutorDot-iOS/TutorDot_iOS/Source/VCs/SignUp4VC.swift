//
//  SignUp4VC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/10.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class SignUp4VC: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordReTextfield: UITextField!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var numberlabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()

    }
    
    @IBAction func backButtonSelected(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpViews() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: passwordTextfield.frame.size.height - 1, width: passwordTextfield.frame.size.width, height: 0.8);
        bottomBorder.backgroundColor = UIColor.veryLightPink.cgColor
        passwordTextfield.layer.addSublayer(bottomBorder)
        
        let bottomBorder2 = CALayer()
        bottomBorder2.frame = CGRect(x: 0.0, y: passwordReTextfield.frame.size.height - 1, width: passwordReTextfield.frame.size.width, height: 0.8);
        bottomBorder2.backgroundColor = UIColor.veryLightPink.cgColor
        passwordReTextfield.layer.addSublayer(bottomBorder2)
        
        serviceLabel.textColor = UIColor.brownishGrey
        numberlabel.textColor = UIColor.brownishGrey
        signUpButton.layer.cornerRadius = 10
        signUpButton.backgroundColor = UIColor.softBlue
        
    }
    
    @IBAction func signUpSelected(_ sender: Any) {
        guard let uvc = storyboard?.instantiateViewController(withIdentifier: "SignUpDoneVC") else { return }
        self.navigationController?.pushViewController(uvc, animated: true)
        
    }
    


}
