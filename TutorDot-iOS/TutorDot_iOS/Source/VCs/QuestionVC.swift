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
  
    @IBOutlet weak var barview: UIView!
    @IBOutlet weak var questionTabView: UIView!
  
    
    @IBOutlet weak var blindView: UIView!
    @IBOutlet weak var answerCount: UILabel!
    @IBOutlet weak var questionCount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextBox()
        setDefault()
        
        // Mark: - shadow setting
        self.view.bringSubviewToFront(questionBoxView)
        self.view.bringSubviewToFront(questionHeaderView)
        self.view.bringSubviewToFront(blindView)
        questionTableView.delegate = self
        questionTableView.dataSource = self
    }
    
    func setDefault(){
        questionTabView.layer.backgroundColor = UIColor.whiteTwo.cgColor
        questionTableView.backgroundColor = UIColor.whiteTwo
        questionCount.textColor = UIColor.fontSoftBlue
        
        
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

extension QuestionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        guard let Cell = tableView.dequeueReusableCell(withIdentifier: QuestionListCell.identifier, for: indexPath) as? QuestionListCell
        else { return UITableViewCell() }
        
        return Cell
    }
    
    
}
