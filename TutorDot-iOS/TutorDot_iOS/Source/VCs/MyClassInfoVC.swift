//
//  MyClassInfoVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/15.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class MyClassInfoVC: UIViewController {
    
    static let idnetifier: String = "MyClassInfoVC"
    var myRole: String = ""
    var classId: Int = 0
    
    @IBOutlet weak var classTimeHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var headerHeightContraints: NSLayoutConstraint!
    @IBOutlet weak var classColorImage: UIImageView!
    @IBOutlet weak var Role: UILabel!
    @IBOutlet weak var TutorProfileImage: UIImageView!
    @IBOutlet weak var timeAndPrice: UILabel!
    @IBOutlet weak var bankAccountInfo: UILabel!
    @IBOutlet weak var regularClassTime: UILabel!
    @IBOutlet weak var classPlace: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var tutorIntro: UILabel!
    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var stackList: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimesData()
        autoLayoutView()
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if myRole == "튜티" {
            //튜티일경우 과외 초대 및 편집버튼 숨기기
            stackList.subviews[6].isHidden = true
            editButton.isHidden = true
        }
    }
    
    func autoLayoutView(){
        headerHeightContraints.constant = self.view.frame.height * 94/812
    }
    func setTimesData(){
        let classTimeBasicHeight: CGFloat = 83
        var timesList: [String] = []
        var printtimeList: String = ""
        //시간 데이터 받아와서 추가
        timesList.append("월 01:00pm ~ 03:00pm")
        timesList.append("금 01:00pm ~ 03:00pm")
        for i in timesList {
            print(i)
            printtimeList += i
            printtimeList += "\n"
        }
        regularClassTime.text = printtimeList
        classTimeHeightConstraints.constant = classTimeBasicHeight + CGFloat((timesList.count * 20))
    }
    
    @IBAction func editButtonDidTap(_ sender: Any) {
        guard let editVC = self.storyboard?.instantiateViewController(identifier: "MypageClassEditVC") as? MypageClassEditVC else {return}
        
        
            editVC.modalPresentationStyle = .currentContext
            editVC.modalTransitionStyle = .crossDissolve
       
        
        
        
            editVC.titleEdit = classTitle.text
//            editVC.color = emailTextField.text
            editVC.price = "80 만원"
            editVC.hours = "16 시간"
            editVC.bank = "카카오뱅크"
            editVC.account = "83191012665607"
            editVC.place = classPlace.text
            
        
            self.present(editVC, animated: true, completion: nil)
    }
    
    @IBAction func inviteButtonDidTap(_ sender: Any) {
        //튜터가 튜티를 초대 TuteeInviteCodeVC
        let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "TutorClassInviteVC")
        nextVC.modalPresentationStyle = .currentContext
        nextVC.modalTransitionStyle = .crossDissolve
        present(nextVC, animated: true, completion: nil)
        
  
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

