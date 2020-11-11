//
//  BottomNotchVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/11.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation
import UIKit

class BottomNotchVC: UIViewController {
    
    //Mark: - Bottom Sheet Handle
    
    var handleView: UIView = {
        var handleView = UIView()
        handleView.backgroundColor = UIColor.gray
        handleView.translatesAutoresizingMaskIntoConstraints = false
        handleView.layer.cornerRadius = 4.0
        return handleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(handleView)
        
        NSLayoutConstraint.activate([
            self.handleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.handleView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.handleView.heightAnchor.constraint(equalToConstant: 5),
            self.handleView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
