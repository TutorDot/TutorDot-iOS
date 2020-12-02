//
//  MyPageVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 29/06/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os
import Kingfisher

import SafariServices

import Lottie


class MyPageVC: UIViewController {

    // 프로필 설정
    var profileURL: String = ""
    let introDefault: String = "한 줄 소개"
    let defaultURL: String = "https://sopt-26-usy.s3.ap-northeast-2.amazonaws.com/1606475856445.png"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var classCollectionView: UICollectionView!
    
    @IBOutlet weak var myClassAddButton: UIButton!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var myRole: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIntro: UILabel!
    @IBOutlet weak var profileEditButton: UIButton!
    
    @IBOutlet weak var dummyView: UIView!
    var classId: [Int] = []
    var UserRole: String = ""
    
    @IBOutlet weak var dummyImageView: UIImageView!
    let dummyUser = "dummy"
    private var refreshControl = UIRefreshControl()
    var ClassListDidSelect: Bool = true
    var firstTimeRuning: Bool = true
    
    
    @IBOutlet var mainView: UIView! // VC 최상위뷰
    let animationView = AnimationView()
    
    func loadingAnimation(){
        
        animationView.animation = Animation.named("final") // 로티 이름으로 애니메이션 등록
        animationView.frame = view.bounds
        print(self.view.frame.size.height / 2, "눂이")
        if self.view.frame.size.height > 700 {
            animationView.frame = CGRect(x: 0, y: self.view.frame.size.height / 2 - 100, width: animationView.frame.size.width, height: animationView.frame.size.height)
        } else {
            animationView.frame = CGRect(x: 0, y: self.view.frame.size.height / 2 - 60, width: animationView.frame.size.width, height: animationView.frame.size.height)
        }
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        self.mainView.addSubview(animationView)
        animationView.play()
    }
    
    func loadingAnimationStop(){
        
        animationView.stop()
        animationView.removeFromSuperview()
//        animationView.layer.removeAllAnimations()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSettingView()
        setMyclassViews()
        setProfile()
        gotoProfileEdit()
        setMyClassInfos() // 수업 리스트 셋팅
        tableView.delegate = self
        tableView.dataSource = self
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        
        // scroll refresh
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        classCollectionView.register(UINib.init(nibName: "MypageNoClassCell", bundle: nil), forCellWithReuseIdentifier: "MypageNoClassCell")
        
        if "\(UserDefaults.standard.value(forKey: "save_userNm")!)" == dummyUser {
            dummyView.isHidden = false
        } else {
            dummyView.isHidden = true
        }
        loadingAnimation()
        var appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        
    }
    
    @objc func refresh(){
        // refresh Action
        MyClassInfos.removeAll()
        setMyClassInfos()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        classCollectionView.isScrollEnabled = true
        classCollectionView.contentSize = CGSize(width: 206, height: 81)
        
        if firstTimeRuning {
            firstTimeRuning = false
        } else {
            setMyClassInfos()
            setProfile()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        MyClassInfos.removeAll()
        classId.removeAll()
    }
    
  
    
    func setMyclassViews(){
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height / 2
        myClassAddButton.layer.cornerRadius = 7
        profileEditButton.layer.cornerRadius = 3
    }
    
    func setUpDummy() {
        dummyImageView.layer.cornerRadius = dummyImageView.frame.height * 0.5
    }
    
    @IBAction func dummyLogin(_ sender: Any) {
        let loginStoryboard = UIStoryboard.init(name: "Login", bundle : nil)
        guard let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
    //상단 콜렉션 뷰에서 쓸 리스트
    private var MyClassInfos: [LidToggleData] = []
    //하단 테이블 뷰에서 쓸 리스트
    private var Alert: [MypageInfo] = []
    private var Info: [MypageInfo] = []
    private var Service: [MypageInfo] = []
    
    func setMyClassInfos(){
        
//        loadingAnimation()
        
        // MARK - 수업 리스트 서버통신
        ClassInfoService.classInfoServiceShared.setMypageClassList() { networkResult in
            switch networkResult {
                case .success(let resultData):
                    guard let data = resultData as? [LidToggleData] else { return print(Error.self) }
                    for index in 0..<data.count {
                        let item = LidToggleData(lectureId: data[index].lectureId, lectureName: data[index].lectureName, color: data[index].color, profileUrls: data[index].profileUrls, schedules: data[index].schedules)
                        
                        self.classId.append(data[index].lectureId)
                        self.MyClassInfos.append(item)
                    }
                    self.classCollectionView.reloadData()
                    self.loadingAnimationStop()
                case .pathErr :
                    os_log("PathErr", log: .mypage)
                    self.loadingAnimationStop()
                case .serverErr :
                    os_log("ServerErr", log: .mypage)
                    self.loadingAnimationStop()
                case .requestErr(let message) :
                    print(message)
                    self.loadingAnimationStop()
                case .networkFail:
                    os_log("networkFail", log: .mypage)
                    self.loadingAnimationStop()
            }
            
            
        }
        
        
      
    }
    
    
    
    func setSettingView(){
        let alert1 = MypageInfo(title: "수업료 알림 (서비스 준비 중)")
        let alert2 = MypageInfo(title: "수업 시작 전 알림 (서비스 준비 중)")
        let info1 = MypageInfo(title: "버전정보")
        let info2 = MypageInfo(title: "개발자정보")
        let service1 = MypageInfo(title: "비밀번호 변경")
        let service2 = MypageInfo(title: "로그아웃")
        let service3 = MypageInfo(title: "서비스 탈퇴")
        
        Alert = [alert1, alert2]
        Info = [info1, info2]
        Service = [service1, service2, service3]
    }
    
    // Mark - 서버통신 : 간편 프로필 조회
    func setProfile(){
        ProfileService.ProfileServiceShared.setMyProfile() { networkResult in
            switch networkResult {
                case .success(let resultData):
                    os_log("profile success", log: .mypage)
                    guard let data = resultData as? UserProfile else { return print(Error.self) }
                        self.usernameLabel.text =  data.userName
                    if data.role == "tutor" {
                        self.myRole.text = "튜터"
                    } else {
                        self.myRole.text = "튜티"
                    }
                    self.UserRole = data.role // tutor or tutee
                        
                    if data.intro == "" {
                        self.userIntro.text = self.introDefault
                        self.userIntro.textColor = UIColor.gray
                    } else {
                        self.userIntro.text = data.intro
                        self.userIntro.textColor = UIColor.black
                    }
                    self.profileURL = data.profileUrl
                    
                    
                    let url = URL(string: self.profileURL)
                    self.userProfileImage.kf.setImage(with: url)

                case .pathErr :
                    os_log("PathErr-Profile", log: .mypage)
                case .serverErr :
                    os_log("ServerErr", log: .mypage)
                case .requestErr(let message) :
                    os_log(message as! StaticString, log: .mypage)
                case .networkFail:
                    os_log("networkFail", log: .mypage)
            }
        }
    }
    
    // 프로필 이미지 뷰 선택시 프로필 편집 화면으로 화면전환
    func gotoProfileEdit(){
        userProfileImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileDidTap))
        userProfileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func profileDidTap(){
        guard let PresentVC = self.storyboard?.instantiateViewController(
                        identifier: "TutorProfileEditVC") as? TutorProfileEditVC else { return }
        PresentVC.modalPresentationStyle = .fullScreen
        
        present(PresentVC, animated: true, completion: nil)
    }
    
    @IBAction func addClassButtonDidTap(_ sender: Any) {
        
        if "\(UserDefaults.standard.value(forKey: "save_userNm")!)" == dummyUser {
            let alertViewController = UIAlertController(title: nil, message: "로그인 후 튜터닷의 튜터링 서비스를 만나보세요!", preferredStyle: .alert)
            let action = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            let login = UIAlertAction(title: "로그인", style: .default, handler: nil)
            alertViewController.addAction(action)
            alertViewController.addAction(UIAlertAction(title: "로그인", style: .default, handler: { (action) in
                let loginStoryboard = UIStoryboard.init(name: "Login", bundle : nil)
                guard let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            } ))
            
            self.present(alertViewController, animated: true, completion: nil)
        } else {
            if myRole.text == "튜터"{
                // 튜터일 때, 수업 추가 뷰로 이동
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MypageNewClassNameVC") as? MypageNewClassNameVC else {return}
                nextVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(nextVC, animated: true)

            } else if myRole.text == "튜티" {
                // 튜티일 때, 수업 초대코드 입력 뷰로 이동
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteCodeVC") as? InviteCodeVC else {return}
                
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
       
    }

    @IBAction func profileEditButtonDidTap(_ sender: Any) {
        guard let PresentVC = self.storyboard?.instantiateViewController(
                        identifier: "TutorProfileEditVC") as? TutorProfileEditVC else { return }
        PresentVC.modalPresentationStyle = .fullScreen
        present(PresentVC, animated: true, completion: nil)
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
                cell.hiddenSwitch()
                
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

//                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DeveloperInfoVC") as? DeveloperInfoVC else {return}
//                nextVC.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(nextVC, animated: true)
                
                guard let url = URL(string: "https://sites.google.com/view/tutordot/%ED%8A%9C%ED%84%B0%EB%8B%B7?authuser=0") else { return }

                    let safariViewController = SFSafariViewController(url: url)

                    present(safariViewController, animated: true, completion: nil)
            }
        case 2:
            if indexPath.row == 0 { //비밀번호 변경 클릭 시
                if "\(UserDefaults.standard.value(forKey: "save_userNm")!)" == dummyUser {
                    let alertViewController = UIAlertController(title: nil, message: "로그인 후 튜터닷의 튜터링 서비스를 만나보세요!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                    let login = UIAlertAction(title: "로그인", style: .default, handler: nil)
                    alertViewController.addAction(action)
                    alertViewController.addAction(UIAlertAction(title: "로그인", style: .default, handler: { (action) in
                        let loginStoryboard = UIStoryboard.init(name: "Login", bundle : nil)
                        guard let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true, completion: nil)
                    } ))
                    
                    self.present(alertViewController, animated: true, completion: nil)
                } else {
                    guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "passwordModifyVC") as? passwordModifyVC else {return}
                    nextVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            } else if indexPath.row == 1 { //로그아웃 클릭 시
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LogoutPopupVC") as? LogoutPopUpVC else {return}
                nextVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            } else if indexPath.row == 2 { //서비스탈퇴 클릭 시
                if "\(UserDefaults.standard.value(forKey: "save_userNm")!)" == dummyUser {
                    let alertViewController = UIAlertController(title: nil, message: "로그인 후 튜터닷의 튜터링 서비스를 만나보세요!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                    let login = UIAlertAction(title: "로그인", style: .default, handler: nil)
                    alertViewController.addAction(action)
                    alertViewController.addAction(UIAlertAction(title: "로그인", style: .default, handler: { (action) in
                        let loginStoryboard = UIStoryboard.init(name: "Login", bundle : nil)
                        guard let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true, completion: nil)
                    } ))
                    
                    self.present(alertViewController, animated: true, completion: nil)
                } else {
                    guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LeaveServiceVC") as? LeaveServiceVC else {return}
                    nextVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
            }
            
        default:
            print("default")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
    }
}


extension MyPageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if MyClassInfos.count == 0 {
            return  1 // blank Cell
        } else {
            return MyClassInfos.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if MyClassInfos.count == 0 {
            
            ClassListDidSelect = false
            
            guard let blankcell = collectionView.dequeueReusableCell(withReuseIdentifier: "MypageNoClassCell", for: indexPath) as? MypageNoClassCell else { return UICollectionViewCell() }
            
            
            return blankcell
            
        } else {
            
            ClassListDidSelect = true
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyClassCell.identifier, for: indexPath) as? MyClassCell else { return UICollectionViewCell() }
            

            if MyClassInfos[indexPath.row].profileUrls.isEmpty {
                cell.setMyClassInfo(classColor: MyClassInfos[indexPath.row].color, classTitle: MyClassInfos[indexPath.row].lectureName, Tutee: self.defaultURL, classTime: MyClassInfos[indexPath.row].schedules)
            } else {
                cell.setMyClassInfo(classColor: MyClassInfos[indexPath.row].color, classTitle: MyClassInfos[indexPath.row].lectureName, Tutee: MyClassInfos[indexPath.row].profileUrls[0].profileUrl, classTime: MyClassInfos[indexPath.row].schedules)
            }
            
            
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if "\(UserDefaults.standard.value(forKey: "save_userNm")!)" == dummyUser {
            let alertViewController = UIAlertController(title: nil, message: "로그인 후 튜터닷의 튜터링 서비스를 만나보세요!", preferredStyle: .alert)
            let action = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            let login = UIAlertAction(title: "로그인", style: .default, handler: nil)
            alertViewController.addAction(action)
            alertViewController.addAction(UIAlertAction(title: "로그인", style: .default, handler: { (action) in
                let loginStoryboard = UIStoryboard.init(name: "Login", bundle : nil)
                guard let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            } ))
            
            self.present(alertViewController, animated: true, completion: nil)
        } else {
            if ClassListDidSelect == true {
                
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MyClassInfoVC") as? MyClassInfoVC else {return}
                nextVC.hidesBottomBarWhenPushed = true
                
                //데이터 전달
                nextVC.classId = self.classId[indexPath.row]
                nextVC.userRole = self.UserRole
                
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }
        }
        
    }
    

}


