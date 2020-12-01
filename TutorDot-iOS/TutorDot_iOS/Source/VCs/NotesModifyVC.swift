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
    let weekdayStr: [String] = ["","일", "월", "화", "수", "목", "금", "토"]
    let defaultLesson: String  = "진도를 입력해주세요"
    let defaultHW: String  = "숙제를 입력해주세요"
    
    // 받을 데이터
    var diaryID: Int = 0
    var color: String = ""
    var lesson: String = ""
    var hw: String = ""
    var times: Int = 0
    var hour: Int = 0
    var totalHours: Int = 0
    var lectureName: String = ""
    var date: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        autoLayoutView()
    }
    
    func setUpView(){
        classColor.image = UIImage(named: color)
        classTitle.text = lectureName
        classCount.text = "\(times)" + "회차  " + "\(hour)" + "시간 / " + "\(totalHours)" + "시간"
        
        if lesson == self.defaultLesson {
            lessonTextField.text = ""
        } else {
            lessonTextField.text = lesson
        }
        
        if hw == self.defaultHW {
            homeworkTextField.text = ""
        } else {
            homeworkTextField.text = hw
        }
        
        // "Date" String ro Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let finalDate: Date = dateFormatter.date(from: date)!
        
        // 요일 구하기
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: finalDate)
        
        let index = date.index(date.endIndex, offsetBy: -2)
        dateLabel.text = String(date[index...]) + "일 " + weekdayStr[comps.weekday!]
    }
    
    func autoLayoutView(){
        backView.layer.cornerRadius = 13
        headerHeightConstraints.constant = view.frame.height * 94/812
        
    }

    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    


}
