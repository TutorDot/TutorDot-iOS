//
//  MypageNewClassTimeVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/26.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit





class MypageNewClassTimeVC: UIViewController, UITextFieldDelegate  {

    static let identifier: String = "MypageNewClassTimeVC"
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var timePlusView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var place: UITextField!
    
    let classAddedHeight: CGFloat = 37
    var currentRow: Int = 0
    // 이전 뷰에서 받을 내용들
    var className: String = ""
    var classColor: String = ""
    var classTime: Int = 0
    var classPrice: Int = 0
    var tutorBank: String = ""
    var tutorBanckAccout: String = ""
    
    // 현재 뷰에서 받는 내용
    var defaultClassTime: [String] = []
   
    var schedules: [Schedules] = []
    var classPlace: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        place.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        place.addTarget(self, action: #selector(InviteCodeVC.textFieldDidChange(_:)), for: .editingChanged)
        
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.classPlace = place?.text ?? ""
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -80 // Move view 80 points upward
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0// Move view 80 points upward
    }
    
    
    func setDefault(){
        completeButton.layer.cornerRadius = 8
        timePlusView.layer.cornerRadius = 8
        tableViewHeight.constant = classAddedHeight * CGFloat(defaultClassTime.count)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func placeDelDidTap(_ sender: Any) {
        place.text = ""
    }
    
    @IBAction func completeButtonDidTap(_ sender: Any) {
        // AddClassCompleteVC
        // Mark - 수업 추가 서버 통신
        print(classTime)
        print("수업 추가 - 수업 시간목록")
        AddLectureService.AddLectureServiceshared.addLecture(className, classColor, schedules, classPlace, tutorBank, tutorBanckAccout, classTime, classPrice, schedules.count) {
            networkResult in
            switch networkResult {
            case .success(let token) :

                // 서버 통신 성공 후 성공 뷰로 이동
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AddClassCompleteVC") as? AddClassCompleteVC else {return}
                self.navigationController?.pushViewController(nextVC, animated: true)
                
                guard let token = token as? String else { return }
                UserDefaults.standard.set(token, forKey: "token")
                
                
            case .requestErr(let message) :
                guard let message = message as? String else { return }
                let alertViewController = UIAlertController(title: "수업추가 실패", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertViewController.addAction(action)
                self.present(alertViewController, animated: true, completion: nil)
            case .pathErr:
                print("path")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
        
        
        
    }
    
    // 화면 터치 시, 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func classTimeAddedDidTap(_ sender: Any) {
        if defaultClassTime.count < 5 {
            defaultClassTime.append("append Cell")
            tableView.reloadData()
            tableViewHeight.constant = classAddedHeight * CGFloat(defaultClassTime.count)
            
            UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
            }
        } else {
            // 수업시간 5개 초과 시 경고창 띄우기
            let alertViewController = UIAlertController(title: "등록횟수 초과", message: "수업시간은 5개까지 입력이 가능합니다.", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    

    
    

}


extension MypageNewClassTimeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.defaultClassTime.count == 0 {
            return 0
        } else {
            return classAddedHeight
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        return defaultClassTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: AddRegularClassTimeCell.identifier, for: indexPath) as? AddRegularClassTimeCell else { return UITableViewCell()}
        
        cell.delegate = self
        
        return cell
    }
    
}


extension MypageNewClassTimeVC: TimeSendDelegate {
    func classTimesend(_ days: String, _ startTime: String, _ endTime: String) {
        let schedule = Schedules(days, startTime, endTime)
        schedules.append(schedule)
    }
    
    func classTimeDelete(){
        if schedules.count > 0 {
            schedules.removeLast()
        }
    }
    
}
