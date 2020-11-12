//
//  CalendarVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 29/06/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
import UIKit
import DropDown
import Foundation
import Sheeeeeeeeet

protocol CalendarViewControllerDeleagte {
    func didSelectDate(dateString: String)
}

class CalendarVC: UIViewController {
    
    static let identifier: String = "CalendarVC"
    
    var dropDown: DropDown?
    var classList: [CalendarData] = [] // 수업 더미 데이터
    var classDateList: [CalendarData] = [] // 날짜별 일정 리턴 데이터
    var classList2: [CalendarData] = [] // 서버에서 받아오는 날짜 데이터
    var dropDownList: [String] = [] // 서버에서 받아오는 수업정보 데이터: 드랍다운 리스트
    var classListToggle: [CalendarData] = [] // 토글 버튼 누르면 새로 수업 정보 데이터 저장되는 리스트
    var classList2Copy: [CalendarData] = [] // 서버에서 받아오는 날짜 데이터 백업
    
    var translation: CGPoint!
    var startPosition: CGPoint! //Start position for the gesture transition
    var originalHeight: CGFloat = 0 // Initial Height for the UIView
    var difference: CGFloat!
    
    // MARK: Calendar variables
    var index: IndexPath? // 오늘 날짜 인덱스 저장 변수
    var nextDate : Int = 0 // 다음 날짜 초기화
    var returnvalue: Int = 0
    var months = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    var lastWeekDayOfMonth = 0
    var currentMonthIndexConstant = 0
    var delegate: CalendarViewControllerDeleagte?
    
    
    let numberOfPastMonths: Int = 12
    let numberOfFutureMonths: Int = 12
    let calendar = Calendar.init(identifier: .gregorian)
    var firstTimeRunning = true
    var selectedDate: Date?
    var startingScrollingOffset = CGPoint.zero


    let swipeRec = UISwipeGestureRecognizer()
    
    
    @IBOutlet weak var headerUserNameLabel: UILabel!
    @IBOutlet weak var headerClassNameLabel: UILabel!
    
    
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var tutorView: UIView!
    @IBOutlet weak var tutorCollectionView: UICollectionView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var dropDownLabelButton: UIButton!
    @IBOutlet weak var topDateButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var dateHeaderLabel: UILabel!
    @IBOutlet weak var monthHeaderLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tutorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var totalView: UIView!
    
    @IBOutlet weak var anchorView: UIView!
    
    
    @IBOutlet weak var calendarView: UIView! {
        didSet {
            calendarView.layer.cornerRadius = 20
            calendarView.layer.shadowRadius = 10
            calendarView.layer.shadowColor = UIColor.gray.cgColor
            calendarView.layer.shadowOffset = CGSize(width: 1, height: 1)
            calendarView.layer.shadowOpacity = 0.5
            calendarView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
        }
    }
    
    @IBOutlet weak var buttonShadown: UIButton! {
        didSet {
            buttonShadown.layer.shadowOffset = CGSize(width: 0, height: 3)
            buttonShadown.layer.shadowOpacity = 0.5
            buttonShadown.layer.shadowRadius = 5.0
            buttonShadown.layer.masksToBounds = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
        setupCalendar()
        setUpView()
        getClassList()
        setListDropDown()
        self.view.sendSubviewToBack(calendarView)
        self.dateCollectionView.allowsMultipleSelection = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.dateCollectionView.selectItem(at: index, animated: true, scrollPosition: [])
//        self.collectionView(self.dateCollectionView, didSelectItemAt: index ?? [0,0])
                if firstTimeRunning {
                
                    dateCollectionView.scrollToItem(at: IndexPath(item: 0, section: numberOfPastMonths), at: .centeredVertically, animated: false)
                    firstTimeRunning = false
                }
        self.dateCollectionView.allowsMultipleSelection = true
 
    }
    
    // MARK: - 서버통신: 수업 리스트 가져오기
    func setListDropDown(){
        var dropList : [String] = ["전체"]
        dropDown = DropDown()
        self.dropDown?.width = self.view.frame.width
        self.dropDown?.backgroundColor = UIColor.white
        self.dropDown?.selectionBackgroundColor = UIColor.paleGrey
        self.dropDown?.cellHeight = 60
        DropDown.appearance().setupCornerRadius(17)
        self.dropDown?.anchorView = anchorView
        self.dropDown?.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.dropDown?.setupMaskedCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner])
        //self.dropDown?.topOffset = CGPoint(x: 0, y:-(dropDown?.anchorView?.plainView.bounds.height)!)
        
        // 서버통신: 토글에서 수업리스트 가져오기
        ProfileService.shared.getClassLid() { networkResult in
            switch networkResult {
            case .success(let resultData):
                guard let data = resultData as? [LidToggleData] else { return print(Error.self) }
                for index in 0..<data.count {
                    let item = LidToggleData(lectureId: data[index].lectureId, lectureName: data[index].lectureName, color: data[index].color, profileUrls: data[index].profileUrls)
                    dropList.append(item.lectureName)
                    self.dropDown?.dataSource = dropList
                    print(item)
                }
                
            case .pathErr : print("Patherr")
            case .serverErr : print("ServerErr")
            case .requestErr(let message) : print(message)
            case .networkFail:
                print("networkFail")
            }
        }
        // 드롭박스 목록 내역
        dropDownLabelButton.addTarget(self, action: #selector(dropDownToggleButton), for: .touchUpInside)
        self.dateCollectionView.reloadData()
        self.tutorCollectionView.reloadData()
        
        // 드롭박스 수업 제목 선택할 때 캘린더 컬렉션뷰, 튜터 컬렉션뷰 데이터 바꿔주기
        dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.classListToggle.removeAll()
            self.tutorCollectionView.reloadData()
            
            // 전체 선택시
            if self.dropDown?.selectedItem == "전체" {
                self.classList2 = self.classList2Copy
                self.dateCollectionView.reloadData()
                self.tutorCollectionView.reloadData()
                self.headerClassNameLabel.text = "전체"
            } else {
                self.classList2 = self.classList2Copy
                for i in 0..<self.classList2.count {
                    if self.dropDown?.selectedItem == self.classList2[i].lectureName {
                        self.classListToggle.append(self.classList2[i])
                        self.headerClassNameLabel.text = self.classList2[i].lectureName
                    }
                }
                self.classList2.removeAll()
                self.classList2 = self.classListToggle
                self.dateCollectionView.reloadData()
                self.tutorCollectionView.reloadData()
            }
        }
        // 드롭박스 내 text 가운데 정렬
        dropDown?.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.textAlignment = .center
        }
    }
    
    func setUpView() {
        headerViewHeightConstraint.constant = view.frame.height * 130/812
        self.calendarCollectionViewHeightConstraint.constant = 290
        self.calendarViewHeightConstraint.constant = 330
    }
    
    @objc func dropDownToggleButton(){
        self.dropDown?.reloadAllComponents()
        dropDown?.direction = .top
        dropDown?.show()
    }
    
    // MARK: - 서버통신: 캘린더 전체 데이터 가져요기
    func getClassList() {
        ClassInfoService.classInfoServiceShared.getAllClassInfo() { networkResult in
            switch networkResult {
            case .success(let resultData):
                guard let data = resultData as? [CalendarData] else { return print(Error.self) }
                for index in 0..<data.count {
                    let item = CalendarData(classId: data[index].classId, lectureName: data[index].lectureName, color: data[index].color, times: data[index].times, hour: data[index].hour, location: data[index].location, classDate: data[index].classDate, startTime: data[index].startTime, endTime: data[index].endTime)
                    self.classList2.append(item)
                    self.classList2Copy = self.classList2
                }
                self.dateCollectionView.reloadData()
                self.tutorCollectionView.reloadData()
                self.nextDate = 0
            case .pathErr : print("Patherr")
            case .serverErr : print("ServerErr")
            case .requestErr(let message) : print(message)
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    @IBAction func leftButtonSelected(_ sender: Any) {
        currentMonthIndex -= 1
        self.nextDate = 0
        // 1월 전으로 가면 달 리셋
        if currentMonthIndex < 0 {
            currentMonthIndex = 11
            currentYear -= 1
        }
        topDateButton.setTitle("\(currentYear)년 \(months[currentMonthIndex])", for: .normal)
        
        // 2월 일 수 처리
        if currentMonthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[currentMonthIndex] = 29
            } else {
                numOfDaysInMonth[currentMonthIndex] = 28
            }
        }
        firstWeekDayOfMonth = getFirstWeekDay()
        dateCollectionView.reloadData()
        classDateList.removeAll()
        tutorCollectionView.reloadData()
    }
    
    
    @IBAction func rightButtonSelected(_ sender: Any) {
        currentMonthIndex += 1
        self.nextDate = 0
        // 12월 넘어가면 달 리셋
        if currentMonthIndex > 11 {
            currentMonthIndex = 0
            currentYear += 1
        }
        topDateButton.setTitle("\(currentYear)년 \(months[currentMonthIndex])", for: .normal)
        // 2월 일 수 처리
        if currentMonthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[currentMonthIndex] = 29
            } else {
                numOfDaysInMonth[currentMonthIndex] = 28
            }
        }
        firstWeekDayOfMonth = getFirstWeekDay()
        dateCollectionView.reloadData()
        classDateList.removeAll()
        tutorCollectionView.reloadData()
    }
    
    // MARK: -- 서버통신: 일정추가 버튼
    @IBAction func plusButtonSelected(_ sender: Any) {
        guard let receiveViewController = self.storyboard?.instantiateViewController(identifier: ClassAddVC.identifier) as? ClassAddVC else {return}
        receiveViewController.modalPresentationStyle = .fullScreen
        self.present(receiveViewController, animated: true, completion: nil)
    }
    
    @IBAction func alertTabButton(_ sender: Any) {
        let alertStoryboard = UIStoryboard.init(name: "Alert", bundle : nil)
        let uvc = alertStoryboard.instantiateViewController(withIdentifier: "AlertVC")
        uvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(uvc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
    }
    
}

extension CalendarVC {
    func setupViewControllerUI() {
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        tutorCollectionView.delegate = self
        tutorCollectionView.dataSource = self
    }
    
    // MARK: - Calendar Initial setup
    func setupCalendar() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentMonthIndexConstant = Calendar.current.component(.month, from: Date()) // 바뀌지 않는 이번달 변수
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date()) // 오늘 날짜
        currentMonthIndex -= 1
        
        firstWeekDayOfMonth = getFirstWeekDay()
        lastWeekDayOfMonth = getLastWeekDay()
        
        // 2월 날짜 처리
        if currentMonthIndex == 1 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex] = 29
        }
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        
        // 현재 년, 월 타이틀에 보이기
        topDateButton.setTitle("\(currentYear)년 \(months[currentMonthIndex])", for: .normal)
        
        // 처음 열었을 때 오늘 날짜로 보이기
        dateHeaderLabel.text = String(todaysDate)
        monthHeaderLabel.text = String("\(presentMonthIndex+1)월")
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex+1)-01".date?.firstDayOfTheMonth.weekday)!
        return day
    }
    
    func getLastWeekDay() -> Int {
        let lastDay = ("\(currentYear)-\(currentMonthIndex+1)-01".date?.lastDayOfTheMonth.weekday)!
        return lastDay
    }
    
    private func year(at indexPath: IndexPath) -> Int {
        let shiftedDate = calendar.date(byAdding: .month, value: indexPath.section - numberOfPastMonths, to: Date())!
        let year = calendar.component(.year, from: shiftedDate)
        return year
    }
    
    /// Returns month that should be displayed at the specified index path
    private func month(at indexPath: IndexPath) -> Int {
        let shiftedDate = calendar.date(byAdding: .month, value: indexPath.section - numberOfPastMonths, to: Date())!
        let month = calendar.component(.month, from: shiftedDate)
        return month
    }
    
    /// Returns the day of month that should be displayed at the specified index path
    private func day(at indexPath: IndexPath) -> Int? {
        let year = self.year(at: indexPath)
        let month = self.month(at: indexPath)
        
        // Account for the empty filler cells at the start of the month when
        // determining the day for the index path
        let day = indexPath.row - dayOffset(year: year, month: month) + 1
        
        guard day >= 1 else {
            return nil
        }
        
        return day
    }
    
    /// Returns the day offset for the specified year and month. The day
    /// offset is used to shift the days in the calendar view so the weekday
    /// ordinal is aligned with the correct weekday.
    private func dayOffset(year: Int, month: Int) -> Int {
        // Get the weekday ordinal for the first day of the month
        let firstOfMonthDateComponents = DateComponents(calendar: calendar, year: year, month: month, day:  1)
        let startOfMonth = calendar.date(from: firstOfMonthDateComponents)!
        let dayOffset = calendar.component(.weekday, from: startOfMonth) - 1
        return dayOffset
    }
    
    
}


extension CalendarVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 12 past months + 12 future months + current month
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 날짜 뷰
        
        let indexPath = IndexPath(item: 0, section: section)
        
        let year = self.year(at: indexPath)
        let month = self.month(at: indexPath)
        let dateComponents = DateComponents(year: year, month: month)
        let date = calendar.date(from: dateComponents)!
   
        let daysInMonth = calendar.range(of: .day, in: .month, for: date)!.count
        let dayOffset = self.dayOffset(year: year, month: month)
        
        return daysInMonth + dayOffset
        
    }
    
    // MARK: 문제의 그 부분!!!!!!!!!
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let calendarCell = CalendarCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        let tutorInfoCell = TutorCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        let tutorBlankCell = TutorBlankCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        
//        let currentMonthCalendarIndex = currentMonthIndex + 1
//        let currentDateCalendarIndex = todaysDate
        
        // CalendarCollectionView
        // Display the weekday ordinal in the calendar cell
        let year = self.year(at: indexPath)
        let month = self.month(at: indexPath)
        if collectionView == self.dateCollectionView {
            if let day = day(at: indexPath) {
                let date = calendar.date(from: DateComponents(calendar: calendar, year: year, month: month, day: day))!
                calendarCell.date = date
                calendarCell.dateLabel?.text = "\(day)"
                // If the day matches today, highlight the number with a different color
                if calendar.compare(date, to: Date(), toGranularity: .day) == .orderedSame {
                    calendarCell.dateLabel?.textColor = .systemOrange
                } else {
                    calendarCell.dateLabel?.textColor = .label
                }
            } else {
                //calendarCell.date = nil
                calendarCell.dateLabel?.text = ""
                calendarCell.dateLabel?.textColor = .label
            }
            
            print(year, month, day)
            topDateButton.setTitle("\(year)년 \(month)", for: .normal)
            return calendarCell
        }
        // TutorCollectionView
        else {
            // 해당 날짜에 수업이 없을 경우
            if classDateList.count == 0 {
                // 빈 셀 리턴
                tutorBlankCell.isUserInteractionEnabled = false
                return tutorBlankCell
                
                // 해당 날짜에 수업이 있을 경우
            } else {
                tutorInfoCell.infoView.frame.size.width = tutorInfoCell.frame.size.width/2
                tutorInfoCell.set(classDateList[indexPath.row])
                for i in 0..<self.classDateList.count {
                    let hourTimes =  "\(self.classDateList[i].times)회차/ \(self.classDateList[i].hour)시간"
                    tutorInfoCell.classHourLabel.text = hourTimes
                }
                return tutorInfoCell
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == self.dateCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
            cell.isUserInteractionEnabled = true
            // If cell has no date, it's just a filler cell
            if let date = cell.date {
                self.selectedDate = date
                //self.performSegue(withIdentifier: "daySegue", sender: self)
                cell.dateLabel.textColor = UIColor.red
            }
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell
        
        // 다른 날짜 선택 시 다시 색 원래대로 바뀌기: 오늘 날짜일때는 다시 보라색으로 돌아오기
        if indexPath == index {
            cell?.dateView.backgroundColor = UIColor.white
            cell?.dateLabel.textColor = UIColor.softBlue
            classDateList.removeAll()
        } else {
            cell?.dateView.backgroundColor = UIColor.white
            cell?.dateLabel.textColor = UIColor.black
            classDateList.removeAll()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.dateCollectionView {
            return CGSize(width: collectionView.frame.width/7.5 , height: collectionView.frame.width/8.5 )
        } else {
            return CGSize(width: collectionView.frame.width , height: collectionView.frame.height/1.5 )
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
       startingScrollingOffset = scrollView.contentOffset
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
       // [...]
       // First, we use the current contentOffset
       // instead of the target one
       let proposedPage = scrollView.contentOffset.x / 20
      
       // If we scroll forward, we need to pass 10% of a page:
       // floor(3.1 + 0.9) != floor(3)
       
       // If we scroll backwards, we need to reach below 90%
       // of the previous one: floor(2.89 + 0.1) == floor(2)
       
       let delta: CGFloat = scrollView.contentOffset.x
          > startingScrollingOffset.x ? 0.9 : 0.1
       // Then, instead of using a flat value, we use the delta value,
       // and we also remove the targetContentOffset logic
       if floor(proposedPage + delta) == floor(proposedPage) {
       // [...]
    }
    
    

}
}
