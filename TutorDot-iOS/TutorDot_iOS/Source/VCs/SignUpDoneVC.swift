//
//  SignUpDoneVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/10.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class SignUpDoneVC: UIViewController {
    static let identifier: String = "SignUpDoneVC"

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var name: String!
    var userId: String!
    var password: String!
    var role: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()

    }
    
    func setUpView() {
        welcomeLabel.textColor = UIColor.brownishGrey
        startButton.backgroundColor = UIColor.softBlue
        startButton.layer.cornerRadius = 10
    }
    

    @IBAction func startButtonSelected(_ sender: Any) {
        guard let mainView = self.storyboard?.instantiateViewController(identifier:"LoginVC") as?
                LoginVC else { return }
    
        if let email = self.userId {
            mainView.emailText = email
        }
        
        if let password = password {
            mainView.passwordText = password
        }
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    

}
