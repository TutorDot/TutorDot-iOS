//
//  SignUpAgreeVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/20.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import BEMCheckBox

class SignUpAgreeVC: UIViewController {
    
    @IBOutlet weak var buttonAll: BEMCheckBox!
    @IBOutlet weak var buttonOne: BEMCheckBox!
    @IBOutlet weak var buttonTwo: BEMCheckBox!
    @IBOutlet weak var confirmButton: UIButton!
    var appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    func setUpView() {
        buttonAll.onTintColor = UIColor.cornflowerBlue
        buttonOne.onTintColor = UIColor.cornflowerBlue
        buttonTwo.onTintColor = UIColor.cornflowerBlue
        buttonAll.onCheckColor = UIColor.cornflowerBlue
        buttonOne.onCheckColor = UIColor.cornflowerBlue
        buttonTwo.onCheckColor = UIColor.cornflowerBlue
        confirmButton.backgroundColor = UIColor.cornflowerBlue
        confirmButton.layer.cornerRadius = 10
    }
    
    @IBAction func entireSelection(_ sender: BEMCheckBox) {
        buttonOne.on = true
        buttonTwo.on = true
    }
    
    @IBAction func confirmButtonSelected(_ sender: Any) {
        guard let receiveViewController = self.storyboard?.instantiateViewController(withIdentifier: SignUpVC.identifier) as? SignUpVC else {return}
        if buttonAll.on == true {
            self.navigationController?.pushViewController(receiveViewController, animated: true)
        }
    }
    
    @IBAction func backButtonSelected(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    
    }
}
