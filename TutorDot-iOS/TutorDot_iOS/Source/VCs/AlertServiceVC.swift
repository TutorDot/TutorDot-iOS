//
//  AlertServiceVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/24.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class AlertServiceVC: UIViewController {
    static let identifier: String = "AlertServiceVC"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
    }
    

    @IBAction func backButtonSelected(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
