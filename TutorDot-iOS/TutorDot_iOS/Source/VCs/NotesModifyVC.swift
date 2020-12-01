//
//  NotesModifyVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/06.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

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
    @IBOutlet weak var hwCheckButton: UIButton!
    

    
    let hwImage: [String] = ["", "hwCheck", "", "hwUnCheck"]
    let weekdayStr: [String] = ["","일", "월", "화", "수", "목", "금", "토"]
    let defaultLesson: String  = "진도를 입력해주세요"
    let defaultHW: String  = "숙제를 입력해주세요"
    
    // 받을 데이터
    var diaryID: Int = 0
    var color: String = ""
    var lesson: String = ""  // 수정 서버통신 parameter
    var hw: String = "" // 수정 서버통신 parameter
    var times: Int = 0
    var hour: Int = 0
    var totalHours: Int = 0
    var lectureName: String = ""
    var date: String = ""
    var hwCheckValue: Int = 0  // 수정 서버통신 parameter
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        autoLayoutView()
        hwCheckButton.addTarget(self, action: #selector(onTapHwButton), for: .touchUpInside)
        lessonTextField.addTarget(self, action: #selector(NotesModifyVC.lessonTextFieldDidChange(_:)), for: .editingChanged)
        homeworkTextField.addTarget(self, action: #selector(NotesModifyVC.hwTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func onTapHwButton(){
        if hwCheckValue == 1 {
            hwCheckValue = 3
        } else {
            hwCheckValue = 1
        }
        hwCheckButton.imageView?.image = UIImage(named: hwImage[hwCheckValue])
    }
    
    @objc func lessonTextFieldDidChange(_ textField: UITextField) {
        self.lesson = lessonTextField?.text ?? ""
    }
    
    @objc func hwTextFieldDidChange(_ textField: UITextField) {
        self.hw = homeworkTextField?.text ?? ""
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
        
        hwCheckButton.imageView?.image = UIImage(named: hwImage[hwCheckValue])
        
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
    
    @IBAction func CompleteButtonDidTap(_ sender: Any) {
        // Mark - 수업일지 수정 서버 통신(PUT)
        NoteService.Shared.editClassNote(classProgress: lesson, homework: hw, hwPerformance: hwCheckValue, diaryId: diaryID) { networkResult in
            switch networkResult {
            case .success(let token):
                guard let token = token as? String else { return }
                UserDefaults.standard.set(token, forKey: "token")
                
                self.dismiss(animated: true, completion: nil)
            case .pathErr:
                os_log("PathErr-EditClass", log: .note)
            case .serverErr :
                os_log("ServerErr", log: .mypage)
            case .requestErr(let message) :
                os_log(message as! StaticString, log: .mypage)
            case .networkFail:
                os_log("networkFail", log: .mypage)
            }
        }
    }
    

}
