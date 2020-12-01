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

class NotesVC: UIViewController {
    
    

    // MARK: - Views
    

    @IBOutlet weak var ClassProgressView: UIView!
    @IBOutlet weak var monthJournalView: UIView!
    @IBOutlet weak var progressViewWrap: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    // MARK: - Layout Constraint
    
    @IBOutlet weak var tableViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var monthJournalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeaderHeight: NSLayoutConstraint!
    
    
    // MARK: - UIButton and UILabel
    
 
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var currentClassLabel: UILabel!
    @IBOutlet weak var totalClassLabel: UILabel!
    @IBOutlet weak var monthLable: UILabel!
    @IBOutlet weak var NoteTitleLabel: UILabel!
    
    var month: Int = 0
    var monthStr: String = ""
    let dateFomatter = DateFormatter()
  
    private var NotesInfos: [NotesContent] = []
    
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
    }
   
    func setProgressInfo(progressRate: String, currentClass: String, totalClass:String){
        
        progressLabel.text = progressRate
        currentClassLabel.text = currentClass
        totalClassLabel.text = totalClass
    }
    
    func setMonthLabel(_ monthInput: Int){
        var monthStr: String
        monthStr = String(monthInput)
        month = monthInput
        monthLable.text = monthStr + "월 수업 일지"
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
    }
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        //추후 분기문으로 바운더리 지정
        if month < 12 {
            month += 1
        } else {
            month = 1
        }
        setMonthLabel(month)
    }
   
   
    func MonthInit(){
        dateFomatter.dateFormat = "MM"
        print("월 정보: ", dateFomatter.hash)
        monthStr = dateFomatter.string(from: Date())
        monthLable.text = monthStr + "월 수업일지"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        MonthInit()
        
        setNotesInfos()
        setProgress()
        classHeaderHidden(true) // 처음엔 수업진행률 안보이도록 설정
        
        //기종별 최상단 헤더뷰 높이 조정
        viewHeaderHeight.constant = self.view.frame.height * 94/812
        
        //스크롤 시 0월 수업일지 부분 숨기기
       // swipeAction()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.tableView.reloadData()

    }
    

   
    func setNotesInfos(){
       // Mark - 수업 일지 전체 조회 서버 통신(GET)
        NoteService.Shared.getAllClassNotes() { networkResult  in
            switch networkResult {
            case .success(let resultData):
                guard let data = resultData as? [NotesContent] else { return print(Error.self) }
                for index in 0..<data.count {
                    let item = NotesContent(diaryId: data[index].diaryId, profileUrl: data[index].profileUrl, lectureName: data[index].lectureName, classDate: data[index].classDate, color: data[index].color, times: data[index].times, hour: data[index].hour, depositCycle: data[index].depositCycle, classProgress: data[index].classProgress, homework: data[index].homework, hwPerformance: data[index].hwPerformance)
           
                    self.NotesInfos.append(item)
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
        return NotesInfos.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let notesCell = tableView.dequeueReusableCell(withIdentifier: JournalDataCell.identifier, for: indexPath) as? JournalDataCell else { return UITableViewCell()}
        
        notesCell.setNoteCell(NotesInfos[indexPath.row].color,
                              NotesInfos[indexPath.row].profileUrl, NotesInfos[indexPath.row].lectureName, NotesInfos[indexPath.row].times, NotesInfos[indexPath.row].hour, NotesInfos[indexPath.row].classProgress, NotesInfos[indexPath.row].homework, NotesInfos[indexPath.row].hwPerformance)
        
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
        headerView.backgroundColor =  UIColor.whiteTwo

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
        
        // 클릭한 수업일지 ID 전달
        nextVC.diaryID = self.NotesInfos[indexPath.row].diaryId
        nextVC.color = self.NotesInfos[indexPath.row].color
        nextVC.lesson = self.NotesInfos[indexPath.row].classProgress
        nextVC.times = self.NotesInfos[indexPath.row].times
        nextVC.hour = self.NotesInfos[indexPath.row].hour
        nextVC.hw = self.NotesInfos[indexPath.row].homework
        nextVC.totalHours = self.NotesInfos[indexPath.row].depositCycle
        nextVC.lectureName = self.NotesInfos[indexPath.row].lectureName
        nextVC.date = self.NotesInfos[indexPath.row].classDate
        nextVC.hwCheckValue = self.NotesInfos[indexPath.row].hwPerformance
        
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
   
}

