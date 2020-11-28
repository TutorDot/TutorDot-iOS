//
//  MypageNewClassTimeVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/26.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit





class MypageNewClassTimeVC: UIViewController {

    static let identifier: String = "MypageNewClassTimeVC"
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var timePlusView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    let classAddedHeight: CGFloat = 37
    
    // 이전 뷰에서 받을 내용들
    var className: String = ""
    var classColor: String = ""
    var classTime: Int = 0
    var classPrice: Int = 0
    var tutorBank: String = ""
    var tutorBanckAccout: String = ""
    
    // 현재 뷰에서 받는 내용
    var defaultClassTime: [String] = []
    @IBOutlet weak var place: UITextField!
    var schedules: [Schedules] = []
    var classPlace: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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

        AddLectureService.AddLectureServiceshared.addLecture(className, classColor, schedules, classPlace, tutorBank, tutorBanckAccout, classTime, classPrice, schedules.count) {
            networkResult in
            switch networkResult {
            case .success(let token) :
                guard let token = token as? String else { return }
                UserDefaults.standard.set(token, forKey: "token")
                // 서버 통신 성공 후 성공 뷰로 이동
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "AddClassCompleteVC") as? AddClassCompleteVC else {return}
                self.navigationController?.pushViewController(nextVC, animated: true)
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
        defaultClassTime.append("append Cell")
        tableView.reloadData()
        tableViewHeight.constant = classAddedHeight * CGFloat(defaultClassTime.count)
        
        UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func placeEndEditing(_ sender: Any) {
        classPlace = place.text ?? ""
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
}
