//
//  NotesVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 29/06/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//
import os
import UIKit
import DropDown

class NotesVC: UIViewController, selectClassProtocol {
    

    @IBOutlet weak var ClassProgressView: UIView!
    @IBOutlet weak var monthJournalView: UIView!
    @IBOutlet weak var progressViewWrap: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    @IBOutlet weak var tableViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var monthJournalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    

 
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var currentClassLabel: UILabel!
    @IBOutlet weak var totalClassLabel: UILabel!
    @IBOutlet weak var monthLable: UILabel!
    @IBOutlet weak var NoteTitleLabel: UILabel!
    
    
    let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector(("swipe:")));
    var month: Int = 0
    var monthStr: String = ""
    var selectClassID: Int = 0 // 특정일지 선택 lid
    let note: String = "수업 일지"
    let dateFormatter = DateFormatter()
    let cal = Calendar(identifier: .gregorian)
//    let dateFomatterDetail = DateFormatter()
    var isFirstRunning: Bool = false
    private var NotesInfos: [NotesContent] = []
    let weekdayStr: [String] = ["","일", "월", "화", "수", "목", "금", "토"]
    var userProfile: String = ""
    var myRole: String = ""
    var islistCall: Bool = false
    
    
    func classHeaderHidden(_ ishide: Bool){
        progressViewWrap.subviews[0].isHidden = ishide
        if ishide { //true(안보일때)
            tableViewTopMargin.constant = 150-94
        } else { //false (보일때)
            tableViewTopMargin.constant = 150
        }
    }
    
    
    // MARK: - Init
    
    func setProgress(){
        
        progressView.layer.cornerRadius = 9
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 9
        progressView.subviews[1].clipsToBounds = true
        
        progressView.tintColor = UIColor.init(named: "Color")
        progressView.progressViewStyle = .default
        UIView.animate(withDuration: 4.0) {
            self.progressView.setProgress(12/16, animated: true)
        }
        progressLabel.text = "75%"
        
        if NoteTitleLabel.text == self.userProfile + "전체 " + self.note {
            classHeaderHidden(true)
            
        } else {
            classHeaderHidden(false)
        }
    }
   
    func setProgressInfo(progressRate: String, currentClass: String, totalClass:String){
        
        progressLabel.text = progressRate
        currentClassLabel.text = currentClass
        totalClassLabel.text = totalClass
    }
    
    // parameter값으로 들어온 숫자로 월 셋팅
    func setMonthLabel(_ monthInput: Int){
        month = monthInput
        monthLable.text = String(monthInput) + "월 수업 일지"
    }
    
    func MonthInit(){
        
        dateFormatter.dateFormat = "MM"
        
        //현재 월 String 값으로 가져오기
        monthStr = dateFormatter.string(from: Date())
        monthLable.text = monthStr + "월 수업일지"
        month = Int(monthStr) ?? 0
        
    }
    

   // MARK: - Button Action

    @IBAction func previousButtonDidTap(_ sender: Any) {
        //추후 분기문으로 바운더리 지정
        if month > 1 {
            month -= 1
        } else {
            month = 12
        }
        setMonthLabel(month)
        
        NotesInfos.removeAll()
        setNotesInfos()
    }
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        //추후 분기문으로 바운더리 지정
        if month < 12 {
            month += 1
        } else {
            month = 1
        }
        setMonthLabel(month)
        NotesInfos.removeAll()
        setNotesInfos()
    }
   
   
    func gestureRecognizer() {
        swipeGestureRecognizer.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(NotesVC.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.tableView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(NotesVC.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.tableView.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            if swipeGesture.direction == UISwipeGestureRecognizer.Direction.left{
                nextButtonDidTap(self)
                UIView.animate(withDuration: 0.7) {
                }
                
            } else if swipeGesture.direction == UISwipeGestureRecognizer.Direction.right{
                previousButtonDidTap(self)
                UIView.animate(withDuration: 0.7) {
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        MonthInit()
        
        setNotesInfos()
        setProgress()
        classHeaderHidden(true) // 처음엔 수업진행률 안보이도록 설정
        setProfile()
        gestureRecognizer()
        
        //기종별 최상단 헤더뷰 높이 조정
        viewHeaderHeight.constant = self.view.frame.height * 94/812
        
        //스크롤 시 0월 수업일지 부분 숨기기
       // swipeAction()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.tableView.reloadData()
        
        isFirstRunning = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFirstRunning == false {
            if islistCall == false {
                setNotesInfos()
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotesInfos.removeAll()
    }
   
    
    // Mark - 서버통신 : 간편 프로필 조회
    func setProfile(){
        ProfileService.ProfileServiceShared.setMyProfile() { networkResult in
            switch networkResult {
            case .success(let resultData):
                guard let data = resultData as? UserProfile else { return print(Error.self) }
                
                self.myRole = data.role
                
                if data.role == "tutor" {
                    self.userProfile = "\(data.userName) 튜터 "
                    
                } else {
                    self.userProfile = "\(data.userName) 튜티 "
                }
                
                self.NoteTitleLabel.text = self.userProfile + "전체 " + self.note
                
            case .pathErr :
                os_log("PathErr-Profile", log: .note)
            case .serverErr :
                os_log("ServerErr", log: .note)
            case .requestErr(let message) :
                os_log(message as! StaticString, log: .note)
            case .networkFail:
                os_log("networkFail", log: .note)
            }
        }
    }
    
    // Mark - 수업 일지 전체 조회 서버 통신(GET)
    func setNotesInfos(){
        NoteService.Shared.getAllClassNotes() { networkResult  in
            switch networkResult {
            case .success(let resultData):
                guard let data = resultData as? [NotesContentServer] else { return print(Error.self) }
                for index in 0..<data.count {
                    
                    // "Date" String ro Date()
                    self.dateFormatter.dateFormat = "yyyy-MM-dd"
                    let finalDate: Date = self.dateFormatter.date(from: data[index].classDate)!

                    // 요일 구하기
                    let comps = self.cal.dateComponents([.weekday], from: finalDate)
                    let dayAndWeek: String = String(data[index].classDate.substring(from: 8)) + "일 " + self.weekdayStr[comps.weekday!]
                    
                    let item = NotesContent(diaryId: data[index].diaryId, profileUrl: data[index].profileUrl, lectureName: data[index].lectureName, classDate: data[index].classDate, color: data[index].color, times: data[index].times, hour: data[index].hour, depositCycle: data[index].depositCycle, classProgress: data[index].classProgress, homework: data[index].homework, hwPerformance: data[index].hwPerformance, dayWeek: dayAndWeek)
                    
                    let cellMonthStr = item.classDate.substring(with: 5..<7)
                    
                    if self.month == Int(cellMonthStr) {
                        // 해당월의 일지정보만 cell 만들 배열에 append
                        self.NotesInfos.append(item)
                    }
                }
                self.tableView.reloadData()
            case .pathErr :
                os_log("PathErr", log: .note)
            case .serverErr :
                os_log("ServerErr", log: .note)
            case .requestErr(let message) :
                print(message)
            case .networkFail:
                os_log("networkFail", log: .note)
                
            }
        }
    }
    
    
    @IBAction func listButtonDidTap(_ sender: Any) {
        
        
        islistCall = true
        NotesInfos.removeAll()
        
        // Mark - 수업리스트 가져오기 서버통신
        NoteService.Shared.getClassList() { networkResult in
            switch networkResult {
            case .success(let resultData):
                guard let data = resultData as? [ClassList] else { return print(Error.self) }
                
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "BottomSheetVC") as? BottomSheetVC else {return}
                nextVC.classlist.append("전체")
                nextVC.lectureId.append(0)
                for index in 0..<data.count {
                    let item = ClassList(lectureId: data[index].lectureId, lectureName: data[index].lectureName, color: data[index].color)
                    
                    nextVC.classlist.append(item.lectureName)
                    nextVC.lectureId.append(item.lectureId)
                }
                
                nextVC.modalPresentationStyle = .overFullScreen
                self.present(nextVC, animated: true, completion: nil)

                nextVC.delegate = self
                
            case .pathErr : print("Patherr")
            case .serverErr : print("ServerErr")
            case .requestErr(let message) : print(message)
            case .networkFail:
                print("networkFail")
            }
        }
        
        
        
    }
    
    @IBAction func alertButtonDidTap(_ sender: Any) {
        let alertStoryboard = UIStoryboard.init(name: "Alert", bundle : nil)
        let uvc = alertStoryboard.instantiateViewController(withIdentifier: "AlertServiceVC")
        uvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(uvc, animated: true)
    }
    
    func sendClassTitle(_ title: String, _ diaryID: Int) {
        self.selectClassID = diaryID
        self.NoteTitleLabel.text = self.userProfile + title + " " + self.note
        self.setProgress()
        
        if diaryID == 0 {
            setNotesInfos() // 전체수업일지 조회
        } else {
            getOneNoteInfo() // 특정수업일지 조회
        }
        
        islistCall = false
    }
    
    // Mark - 특정 수업일지 조회 서버통신
    func getOneNoteInfo(){
        print(selectClassID, "다이어리 조회")
        print(NotesInfos.count)
        NoteService.Shared.getOneClassNotes(diaryId: selectClassID) { networkResult  in
            switch networkResult {
            case .success(let resultData):
                guard let data = resultData as? [NotesContentServer] else { return print(Error.self) }
                for index in 0..<data.count {
                    
                    // "Date" String ro Date()
                    self.dateFormatter.dateFormat = "yyyy-MM-dd"
                    let finalDate: Date = self.dateFormatter.date(from: data[index].classDate)!

                    // 요일 구하기
                    let comps = self.cal.dateComponents([.weekday], from: finalDate)
                    let dayAndWeek: String = String(data[index].classDate.substring(from: 8)) + "일 " + self.weekdayStr[comps.weekday!]
                    
                    let item = NotesContent(diaryId: data[index].diaryId, profileUrl: data[index].profileUrl, lectureName: data[index].lectureName, classDate: data[index].classDate, color: data[index].color, times: data[index].times, hour: data[index].hour, depositCycle: data[index].depositCycle, classProgress: data[index].classProgress, homework: data[index].homework, hwPerformance: data[index].hwPerformance, dayWeek: dayAndWeek)
                    
                    let cellMonthStr = item.classDate.substring(with: 5..<7)
                    
                    if self.month == Int(cellMonthStr) {
                        // 해당월의 일지정보만 cell 만들 배열에 append
                        self.NotesInfos.append(item)
                    }
                }
                self.tableView.reloadData()
            case .pathErr :
                os_log("PathErr", log: .note)
            case .serverErr :
                os_log("ServerErr", log: .note)
            case .requestErr(let message) :
                print(message)
            case .networkFail:
                os_log("networkFail", log: .note)
                
            }
        }
    }
    
}


// MARK: - Extension

extension NotesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let days = Array(Set(self.NotesInfos.map{ $0.dayWeek })).sorted()[section]
        
        return self.NotesInfos.filter{ $0.dayWeek == days }.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return Array(Set(self.NotesInfos.map{ $0.dayWeek })).count
    }
    
 
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let date = Array(Set(self.NotesInfos.map{$0.dayWeek})).sorted()[indexPath.section]
        
        guard let notesCell = tableView.dequeueReusableCell(withIdentifier: JournalDataCell.identifier, for: indexPath) as? JournalDataCell else { return UITableViewCell()}
        

        let dayItems = self.NotesInfos.filter{ $0.dayWeek == date}[indexPath.row]
    
        notesCell.setNoteCell(dayItems.color,
                              dayItems.profileUrl, dayItems.lectureName, dayItems.times, dayItems.hour, dayItems.classProgress, dayItems.homework, dayItems.hwPerformance)
        
        
        return notesCell
    }
    
    
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = JournalDateHeaderView(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 37))
        headerView.backgroundColor = UIColor.whiteTwo
        //Array(Set(self.NotesInfos.map{ $0.dayWeek }))
        headerView.dateLabel.text = String(Array(Set(self.NotesInfos.map{ $0.dayWeek })).sorted()[section])
        
        return headerView

    }
   
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 37
    }
    
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(
                identifier: NotesModifyVC.identifier) as? NotesModifyVC else { return }
        
        let date = Array(Set(self.NotesInfos.map{$0.dayWeek})).sorted()[indexPath.section]
        let dayItems = self.NotesInfos.filter{ $0.dayWeek == date}[indexPath.row]
        
        // 클릭한 수업일지 ID 전달
        nextVC.diaryID = dayItems.diaryId
        nextVC.color = dayItems.color
        nextVC.lesson = dayItems.classProgress
        nextVC.times = dayItems.times
        nextVC.hour = dayItems.hour
        nextVC.hw = dayItems.homework
        nextVC.totalHours = dayItems.depositCycle
        nextVC.lectureName = dayItems.lectureName
        nextVC.date = dayItems.classDate
        nextVC.hwCheckValue = dayItems.hwPerformance
        nextVC.role = self.myRole
        
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
   
}

