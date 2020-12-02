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
    
    let widthDefault: CGFloat = 375 // 레이아웃 기준 아이폰11Pro
    @IBOutlet weak var headerHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView! {
        didSet {
            //그림자 divice별 밸런스 맞추기
            let weight: CGFloat = 2.02 * (UIScreen.main.bounds.width / widthDefault)
            let radius: CGFloat = backView.frame.width / 2.1
            let shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: weight * radius, height: backView.frame.height), cornerRadius: 13)
            
            backView.layer.cornerRadius = 13
            
            backView.layer.masksToBounds = false
            backView.layer.shadowColor = UIColor.lightGray.cgColor
            backView.layer.shadowOffset = CGSize(width: 4, height: 4)
            backView.layer.shadowRadius = 3
            backView.layer.shadowOpacity = 0.3
            backView.layer.shadowPath = shadowPath.cgPath
            
           
        }
    }
    @IBOutlet weak var classColor: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var classCount: UILabel!
    @IBOutlet weak var lessonTextField: UITextField!
    @IBOutlet weak var homeworkTextField: UITextField!
    @IBOutlet weak var hwCheckButton: UIButton!
    @IBOutlet weak var clearButton1: UIButton!
    @IBOutlet weak var clearButton2: UIButton!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var underline1: UIView!
    @IBOutlet weak var underline2: UIView!
    

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
    var role: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        autoLayoutView()
        roleCheck()
        
        hwCheckButton.addTarget(self, action: #selector(onTapHwButton), for: .touchUpInside)
        lessonTextField.addTarget(self, action: #selector(NotesModifyVC.lessonTextFieldDidChange(_:)), for: .editingChanged)
        homeworkTextField.addTarget(self, action: #selector(NotesModifyVC.hwTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    func roleCheck(){
        if role == "tutee"{
            EditButton.isHidden = true
            clearButton1.isHidden = true
            clearButton2.isHidden = true
            underline1.isHidden = true
            underline2.isHidden = true
            self.lessonTextField.isUserInteractionEnabled = false
            self.homeworkTextField.isUserInteractionEnabled = false
        }
    }
    
    @objc func onTapHwButton(){
        if role == "tutor" {
            if hwCheckValue == 1 {
                hwCheckValue = 3
            } else if hwCheckValue == 3 {
                hwCheckValue = 1
            }
            
            hwCheckButton.setImage(UIImage(named: hwImage[hwCheckValue]), for: .normal)
        }
    }
    
    @objc func lessonTextFieldDidChange(_ textField: UITextField) {
        self.lesson = lessonTextField?.text ?? ""
    }
    
    @objc func hwTextFieldDidChange(_ textField: UITextField) {
        self.hw = homeworkTextField?.text ?? ""
    }
    
    @IBAction func lessonClearButtonDidTap(_ sender: Any) {
        lessonTextField.text = ""
    }
    
    @IBAction func hwClearButtonDidTap(_ sender: Any) {
        homeworkTextField.text = ""
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
        
        hwCheckButton.setImage(UIImage(named: hwImage[hwCheckValue]), for: .normal)
        
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
       
        headerHeightConstraints.constant = view.frame.height * 94/812
        
    }

    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CompleteButtonDidTap(_ sender: Any) {
        
        // Mark - 수업일지 수정 서버 통신(PUT)
        NoteService.Shared.editClassNote(classProgress: lesson, homework: hw, hwPerformance: hwCheckValue, diaryId: diaryID) { networkResult in
            switch networkResult {
            case .success:
                self.dismiss(animated: true, completion: nil)
            case .pathErr:
                os_log("PathErr-EditClass", log: .note)
            case .serverErr:
                os_log("ServerErr", log: .mypage)
            case .requestErr(let message) :
                os_log(message as! StaticString, log: .mypage)
            case .networkFail:
                os_log("networkFail", log: .mypage)
            }
        }
    }
    

}
