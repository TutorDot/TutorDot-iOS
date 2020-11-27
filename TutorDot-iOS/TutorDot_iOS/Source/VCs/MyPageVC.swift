//
//  MyPageVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 29/06/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

class MyPageVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var classCollectionView: UICollectionView!
    
    @IBOutlet weak var myClassAddButton: UIButton!
    @IBOutlet weak var tutorImage: UIImageView!
    @IBOutlet weak var myRole: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMyClassInfos()
        setSettingView()
        setMyclassViews()
        
        gotoProfileEdit()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        
        classCollectionView.isScrollEnabled = true
        classCollectionView.contentSize = CGSize(width: 206, height: 81)
    }
    
  
    
    func setMyclassViews(){
        myClassAddButton.layer.cornerRadius = 7
    }
    
    //상단 콜렉션 뷰에서 쓸 리스트
    private var MyClassInfos: [LidToggleData] = []
    //하단 테이블 뷰에서 쓸 리스트
    private var Alert: [MypageInfo] = []
    private var Info: [MypageInfo] = []
    private var Service: [MypageInfo] = []
    
    func setMyClassInfos(){
        
        // MARK - 수업 리스트 서버통신
        ClassInfoService.classInfoServiceShared.setMypageClassList() { networkResult in
            switch networkResult {
                case .success(let resultData):
                    guard let data = resultData as? [LidToggleData] else { return print(Error.self)
                        
                    }
                    for index in 0..<data.count {
                        
                        let item = LidToggleData(lectureId: data[index].lectureId, lectureName: data[index].lectureName, color: data[index].color, profileUrls: data[index].profileUrls)
                        
                        self.MyClassInfos.append(item)
                    }

                    self.classCollectionView.reloadData()
                case .pathErr :
                    os_log("PathErr", log: .mypage)
                case .serverErr :
                    os_log("ServerErr", log: .mypage)
                case .requestErr(let message) :
                    os_log(message as! StaticString , log: .mypage)
                case .networkFail:
                    os_log("networkFail", log: .mypage)
            }
            
            
        }
    }
    
    func setSettingView(){
        let alert1 = MypageInfo(title: "수업료 알림 (서비스 준비 중)")
        let alert2 = MypageInfo(title: "수업 시작 전 알림")
        let info1 = MypageInfo(title: "버전정보")
        let info2 = MypageInfo(title: "개발자정보")
        let service1 = MypageInfo(title: "비밀번호 변경")
        let service2 = MypageInfo(title: "로그아웃")
        let service3 = MypageInfo(title: "서비스 탈퇴")
        
        Alert = [alert1, alert2]
        Info = [info1, info2]
        Service = [service1, service2, service3]
    }
    
    // 프로필 이미지 뷰 선택시 프로필 편집 화면으로 화면전환
    func gotoProfileEdit(){
        tutorImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileDidTap))
        tutorImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func profileDidTap(){
        let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
        let TutorProfileEditVC = storyBoard.instantiateViewController(withIdentifier: "TutorProfileEditVC")
        TutorProfileEditVC.modalPresentationStyle = .currentContext
        TutorProfileEditVC.modalTransitionStyle = .crossDissolve
        present(TutorProfileEditVC, animated: true, completion: nil)
    }
    
    @IBAction func addClassButtonDidTap(_ sender: Any) {
        
        if myRole.text == "튜터"{
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MypageNewClassNameVC") as? MypageNewClassNameVC else {return}
            self.navigationController?.pushViewController(nextVC, animated: true)

        } else if myRole.text == "튜티" {
            let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "TuteeInviteCodeVC")
            nextVC.modalPresentationStyle = .currentContext
            nextVC.modalTransitionStyle = .crossDissolve
            present(nextVC, animated: true, completion: nil)
        }
        
       
    }
    
    
}

extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
            print(Alert.count)
            return Alert.count
        case 1 :
            print(Info.count)
            return Info.count
        case 2 :
            print(Service.count)
            return Service.count
        default :
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MypageNoticeSettingCell.identifier, for: indexPath) as? MypageNoticeSettingCell else { return UITableViewCell()}
                
                cell.setTitleInfo(Alert[indexPath.row].title)
                cell.hiddenSwitch()
                
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MypageNoticeSettingCell.identifier, for: indexPath) as? MypageNoticeSettingCell else { return UITableViewCell()}
                
                cell.setTitleInfo(Alert[indexPath.row].title)
                
                return cell
            }
            
        case 1 :
            if indexPath.row == 0 {
               guard let cell = tableView.dequeueReusableCell(withIdentifier: MypageInfoCell.identifier, for: indexPath) as? MypageInfoCell else { return UITableViewCell()}
                cell.setTitleInfo(Info[indexPath.row].title)
                cell.hiddenButton()
                cell.setVersionLabel()
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MypageInfoCell.identifier, for: indexPath) as? MypageInfoCell else { return UITableViewCell()}
                cell.setTitleInfo(Info[indexPath.row].title)
                return cell
            }
            
        case 2 :
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MypageServiceCell.identifier, for: indexPath) as? MypageServiceCell else { return UITableViewCell()}
            cell.setTitleInfo(Service[indexPath.row].title)
            return cell
            
            
        default :
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55)
        view.backgroundColor = UIColor.white
        
        switch section {
        case 0 :
            let headerTitle = UILabel(frame : CGRect(x: 16, y: 19, width: 60, height: 17))
            headerTitle.text = "알림설정"
            headerTitle.textColor = UIColor.black
            headerTitle.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            view.addSubview(headerTitle)
        case 1 :
            let headerTitle = UILabel(frame : CGRect(x: 16, y: 19, width: 60, height: 17))
            headerTitle.text = "어플정보"
            headerTitle.textColor = UIColor.black
            headerTitle.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            view.addSubview(headerTitle)
            
        case 2 :
            let headerTitle = UILabel(frame : CGRect(x: 16, y: 19, width: 60, height: 17))
            headerTitle.text = "계정설정"
            headerTitle.textColor = UIColor.black
            headerTitle.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            view.addSubview(headerTitle)
        default:
            print("default")
        }
        
        return view
        
        
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 8)
        view.backgroundColor = UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 1.0)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            print("case 0")
        case 1:
             if indexPath.row == 1 { //개발자정보 클릭 시
                let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "DeveloperInfoVC")
                nextVC.modalPresentationStyle = .currentContext
                nextVC.modalTransitionStyle = .crossDissolve
                present(nextVC, animated: true, completion: nil)
            }
        case 2:
            if indexPath.row == 0 { //비밀번호 변경 클릭 시
                let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
                let popupVC = storyBoard.instantiateViewController(withIdentifier: "passwordModifyVC")
                popupVC.modalPresentationStyle = .fullScreen
                present(popupVC, animated: true, completion: nil)
                
            } else if indexPath.row == 1 { //로그아웃 클릭 시
                let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
                let popupVC = storyBoard.instantiateViewController(withIdentifier: "LogoutPopupVC")
                popupVC.modalPresentationStyle = .overCurrentContext
                popupVC.modalTransitionStyle = .crossDissolve
                present(popupVC, animated: true, completion: nil)
            } else if indexPath.row == 2 { //서비스탈퇴 클릭 시
                let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
                let popupVC = storyBoard.instantiateViewController(withIdentifier: "LeaveServiceVC")
                popupVC.modalPresentationStyle = .overCurrentContext
                popupVC.modalTransitionStyle = .crossDissolve
                present(popupVC, animated: true, completion: nil)
            }
            
        default:
            print("default")
        }
    }
}


extension MyPageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MyClassInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyClassCell.identifier, for: indexPath) as? MyClassCell else { return UICollectionViewCell() }
        
        cell.delegate = self;
        
        // Mark: - 프로필 url 꼭 수정!!!
        cell.setMyClassInfo(classColor: MyClassInfos[indexPath.row].color, classTitle: MyClassInfos[indexPath.row].lectureName, Tutee: "myImgProfile")
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
//            let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
//            let popupVC = storyBoard.instantiateViewController(withIdentifier: "MyClassInfoVC")
            
             guard let receiveViewController = self.storyboard?.instantiateViewController(identifier: "MyClassInfoVC") as? MyClassInfoVC else {return}
             receiveViewController.myRole = self.myRole.text
            receiveViewController.modalPresentationStyle = .currentContext
            receiveViewController.modalTransitionStyle = .crossDissolve
            present(receiveViewController, animated: true, completion: nil)
//            if myRole == "튜터" {
//                let popupVC = storyBoard.instantiateViewController(withIdentifier: "MyClassInfoVC")
//                popupVC.modalPresentationStyle = .currentContext
//                popupVC.modalTransitionStyle = .crossDissolve
//                present(popupVC, animated: true, completion: nil)
//            }
//            else if myRole == "튜티" {
//                let popupVC = storyBoard.instantiateViewController(withIdentifier: "MyClassInfoVC")
//                popupVC.modalPresentationStyle = .currentContext
//                popupVC.modalTransitionStyle = .crossDissolve
//                present(popupVC, animated: true, completion: nil)
//            }
            
            
        case 1:
            print("2")
        case 2 :
            print("3")
        default:
            print("default")
        }
    }
}


extension MyPageVC: MyClassCellDelegate {
    func setRole() {
        print("setRole")
    }
    
    func getRole() -> String{
        print("vc role", myRole.text)
        return self.myRole.text ?? "튜터"
    }
    
//    func setRole(_ role : String){
//
//    }
}
