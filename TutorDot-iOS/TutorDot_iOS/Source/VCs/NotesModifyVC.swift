//
//  NotesModifyVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/06.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class NotesModifyVC: UIViewController {

    static let identifier: String = "NotesModifyVC"
  
    @IBOutlet weak var headerHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var classColor: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var classCount: UILabel!
    @IBOutlet weak var lessonTextField: UITextField!
    @IBOutlet weak var homeworkTextField: UITextField!
  

    override func viewDidLoad() {
        super.viewDidLoad()

        autoLayoutView()
        
    }
    
    func autoLayoutView(){
        backView.layer.cornerRadius = 13
        headerHeightConstraints.constant = view.frame.height * 94/812
        
    }

    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    


}
