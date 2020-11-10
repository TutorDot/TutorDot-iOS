//
//  SignUpDoneVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/10.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class SignUpDoneVC: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setUpView() {
        welcomeLabel.textColor = UIColor.brownishGrey
        startButton.backgroundColor = UIColor.softBlue
        startButton.layer.cornerRadius = 10
    }
    

    @IBAction func startButtonSelected(_ sender: Any) {
        let tabbarStoryboard = UIStoryboard.init(name: "MainTab", bundle: nil)
        guard let mainView = tabbarStoryboard.instantiateViewController(identifier:"TabbarVC") as?
            TabbarVC else { return }
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    

}
