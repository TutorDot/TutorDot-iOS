//
//  MyClassInfoVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/15.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os
import Kingfisher

class MyClassInfoVC: UIViewController {
    
    static let idnetifier: String = "MyClassInfoVC"
    var userRole: String = ""
    var classId: Int = 0
    var profileUrl: String = ""
    var classTimeInfo: [String] = []
    
    
    //최대 다섯개 시간 라벨 넣을 수 있음
    let timeLabel00 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 19))
    let timeLabel01 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 19))
    let timeLabel02 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 19))
    let timeLabel03 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 19))
    let timeLabel04 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 19))
    var timeLabels = [UILabel]()
    
    
    @IBOutlet weak var leaveClassLabel: UILabel!
    @IBOutlet weak var classTimeHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var headerHeightContraints: NSLayoutConstraint!
    @IBOutlet weak var classColorImage: UIImageView!
    @IBOutlet weak var Role: UILabel!
    @IBOutlet weak var TutorProfileImage: UIImageView!
    @IBOutlet weak var timeAndPrice: UILabel!
    @IBOutlet weak var bankAccountInfo: UILabel!
    @IBOutlet weak var classPlace: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var tutorIntro: UILabel!
    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var stackList: UIStackView!
    @IBOutlet weak var classTimeStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setTimesData()
        autoLayoutView()
        setupClassDetail()
        isTuteeSet()
        self.tabBarController?.tabBar.isHidden = true
        editButton.isHidden = true
        
        timeLabels.append(timeLabel00)
        timeLabels.append(timeLabel01)
        timeLabels.append(timeLabel02)
        timeLabels.append(timeLabel03)
        timeLabels.append(timeLabel04)
    }
    
    func isTuteeSet(){
        if userRole == "tutee" {
            //튜티일경우 과외 초대 및 편집버튼 숨기기
            stackList.subviews[6].isHidden = true
            leaveClassLabel.text = "수업 방 나가기"
            editButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        TutorProfileImage.layer.cornerRadius = TutorProfileImage.frame.height / 2
    }
    
    func autoLayoutView(){
        headerHeightContraints.constant = self.view.frame.height * 94/812
    }
    
    // Mark - 수업 상세 조회 서버 통신
    func setupClassDetail(){
        ClassInfoService.classInfoServiceShared.setMypageClassDetail(classId: classId) { networkResult in
            switch networkResult {
            case .success(let resultData):
                
                guard let data = resultData as? ClassDetail else { return print(Error.self)}
                
                self.setAllData(data.color, data.lectureName, data.orgLocation, data.bank, data.accountNo, data.depositCycle, data.price, data.userName, data.role, data.intro, data.profileUrl, data.schedules)
                
            case .pathErr :
                os_log("PathErr", log: .mypage)
            case .serverErr :
                os_log("ServerErr", log: .mypage)
            case .requestErr(let message) :
                print(message)
            case .networkFail:
                os_log("networkFail", log: .mypage)
            }
        }
        
    }
        
    func setAllData(_ color: String, _ title: String, _ orgLocation: String, _ bank: String, _ accountNo: String, _ depositCycle: Int, _ price: Int, _ name: String, _ role: String, _ intro: String, _ profileUrl: String, _ schedule: [MySchedulesData]){
       
        self.classColorImage.image = UIImage(named: color)
        self.classTitle.text = title
        
        if orgLocation == "" {
            self.classPlace.text = "지정된 수업 위치가 없습니다."
            self.classPlace.textColor = UIColor.gray
        } else {
            self.classPlace.text = orgLocation
            self.classPlace.textColor = UIColor.black
        }
        
        self.bankAccountInfo.text = bank + "  " + accountNo
        self.timeAndPrice.text = "\(depositCycle)" + "시간 / " + "\(price)" + "만원"
        self.tutorName.text = name
        
        if role == "tutor" {
            self.Role.text = "튜터"
        } else {
            self.Role.text = "튜티"
        }
        
        if intro == "" {
            self.tutorIntro.text = "한 줄 소개"
            self.tutorIntro.textColor = UIColor.gray
        } else {
            self.tutorIntro.text = intro
            self.tutorIntro.textColor = UIColor.black
        }
        
        self.profileUrl = profileUrl
        let url = URL(string: self.profileUrl)
        self.TutorProfileImage.kf.setImage(with: url)
        
        for i in 0...schedule.count-1 {
            let info: String = "\(schedule[i].day)" + " " + "\(schedule[i].orgStartTime)" + " " + "\(schedule[i].orgEndTime)"
            
            self.timeLabels[i].text = info
            self.timeLabels[i].font = UIFont.systemFont(ofSize: 15, weight: .medium)
            classTimeStackView.subviews[i].addSubview(self.timeLabels[i])
//             classTimeStackView.addArrangedSubview(self.timeLabels[0])
            self.classTimeInfo.append(info)
            
        }
        
        

        classTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        classTimeHeightConstraints.constant = 58 + CGFloat((self.classTimeInfo.count * 19))
    }
    


    
    @IBAction func editButtonDidTap(_ sender: Any) {
        let alert: UIAlertController
        
        alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        var cancelAction: UIAlertAction
        var editAll: UIAlertAction
        
        cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction) in
        })
        editAll = UIAlertAction(title: "편집하기", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            self.editClicked()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(editAll)
        self.present(alert,animated: true){
        
        }
        
    }
    
    func editClicked() {
        
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "MypageClassEditVC") as? MypageClassEditVC else { return }
        
        self.navigationController?.pushViewController(editVC, animated: true)
        
    }
    
    @IBAction func inviteButtonDidTap(_ sender: Any) {
        //튜터가 튜티를 초대 TuteeInviteCodeVC
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClassInviteVC") as? ClassInviteVC else { return }
        
        nextVC.classId = self.classId
        
        self.navigationController?.pushViewController(nextVC, animated: true)
  
    }
    
    @IBAction func unconnectButtonDidTap(_ sender: Any) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ClassDisconnectionVC") as? ClassDisconnectionVC else { return }
        
        nextVC.classid = self.classId
        
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
        self.hidesBottomBarWhenPushed = false;
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = false
        segue.destination.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func accountCopyButtonDidTap(_ sender: Any) {
        UIPasteboard.general.string = bankAccountInfo.text
        
        let alertViewController = UIAlertController(title: "완료", message: "계좌번호를 복사했습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    
}

