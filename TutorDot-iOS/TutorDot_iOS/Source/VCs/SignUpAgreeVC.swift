//
//  SignUpAgreeVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/20.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import BEMCheckBox
import SafariServices

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
    
    @IBAction func service1Button(_ sender: Any) {
        guard let url = URL(string: "https://sites.google.com/view/tutordot/%EC%84%9C%EB%B9%84%EC%8A%A4-%EC%9D%B4%EC%9A%A9%EC%95%BD%EA%B4%80") else { return }

            let safariViewController = SFSafariViewController(url: url)

            present(safariViewController, animated: true, completion: nil)


    }
    
    @IBAction func service2Button(_ sender: Any) {
        guard let url = URL(string: "https://sites.google.com/view/tutordot/%EA%B0%9C%EC%9D%B8%EC%A0%95%EB%B3%B4%EC%B2%98%EB%A6%AC%EB%B0%A9%EC%B9%A8") else { return }

            let safariViewController = SFSafariViewController(url: url)

            present(safariViewController, animated: true, completion: nil)


    }
    
}
