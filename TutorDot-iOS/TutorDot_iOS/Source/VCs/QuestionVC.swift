//
//  QuestionVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/12.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController {

    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var questionHeaderView: UIView!
    @IBOutlet weak var questionBox: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextBox()
        questionTableView.backgroundColor = UIColor.newGrey
        self.view.bringSubviewToFront(questionBoxView)
        self.view.bringSubviewToFront(questionHeaderView)
        
    }
    
    @IBOutlet weak var questionBoxView: UIView! {
        didSet {
            questionBoxView.layer.masksToBounds = false
            questionBoxView.layer.shadowColor = UIColor.lightGray.cgColor
            questionBoxView.layer.shadowOffset = CGSize(width: 0, height: 3)
            questionBoxView.layer.shadowOpacity = 0.5
            questionBoxView.layer.shadowRadius = 4
        }
    }
    
    private func setTextBox(){
        questionBox.layer.borderWidth = 1.0
        questionBox.layer.borderColor = UIColor.cornflowerBlue.cgColor
        questionBox.layer.cornerRadius = 4.0
        questionBox.text = "  질문을 입력해주세요."
        questionBox.textColor = UIColor.lightGray
        
        
    }
    

}
