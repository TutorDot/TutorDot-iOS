//
//  CalendarVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 29/06/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
import UIKit
import DropDown
import Foundation

protocol CalendarViewControllerDeleagte {
    func didSelectDate(dateString: String)
}

class CalendarVC: UIViewController {
    
    static let identifier: String = "CalendarVC"
    static let calendarShared = CalendarVC()
    
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
    
    var firstTimeRunning = true
    let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector(("swipe:")));
    

    
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
    @IBOutlet weak var dayHeaderLabel: UILabel!
    @IBOutlet weak var weekDayHeaderLabel: UILabel!
    
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
        setUpView()
        setListDropDown()
        gestureRecognizer()
        setupCalendar()
        getClassList()
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        tutorCollectionView.delegate = self
        tutorCollectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if firstTimeRunning {
            self.dateCollectionView.selectItem(at: index, animated: true, scrollPosition: [])
            self.collectionView(self.dateCollectionView, didSelectItemAt: index ?? [0,0])
            firstTimeRunning = false
        }
        
    }
    
    @objc func refreshView(notification: NSNotification) {
        self.classList2Copy.removeAll()
        self.classList2.removeAll()
        self.classList.removeAll()
    
        setListDropDown()
        //self.dateCollectionView.reloadData()
//        ClassInfoService.classInfoServiceShared.getAllClassInfo() { networkResult in
//            switch networkResult {
//            case .success(let resultData):
//                guard let data = resultData as? [CalendarData] else { return print(Error.self) }
//                for index in 0..<data.count {
//                    let item = CalendarData(classId: data[index].classId, lectureName: data[index].lectureName, color: data[index].color, times: data[index].times, hour: data[index].hour, location: data[index].location, classDate: data[index].classDate, startTime: data[index].startTime, endTime: data[index].endTime)
//                    self.classList2.append(item)
//                    self.classList2Copy = self.classList2
//                }
//                self.dateCollectionView.reloadData()
//                self.tutorCollectionView.reloadData()
//                self.nextDate = 0
//            case .pathErr : print("Patherr")
//            case .serverErr : print("ServerErr")
//            case .requestErr(let message) : print(message)
//            case .networkFail:
//                print("networkFail")
//            }
//        }
        getClassList()
        print("classList2",classList2)
        
        
    }
    func gestureRecognizer() {
        swipeGestureRecognizer.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(CalendarVC.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.calendarView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(CalendarVC.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.calendarView.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            if swipeGesture.direction == UISwipeGestureRecognizer.Direction.left{
                rightButtonSelected(self)
                UIView.animate(withDuration: 0.7) {
                }
            
            } else if swipeGesture.direction == UISwipeGestureRecognizer.Direction.right{
                leftButtonSelected(self)
                UIView.animate(withDuration: 0.7) {
                }
            }
        }
    }

    
    // MARK: - 서버통신: 수업 리스트 가져오기
    func setListDropDown(){
        var dropList : [String] = ["전체"]
        dropDown = DropDown()
        self.dropDown?.width = self.view.frame.width
        self.dropDown?.backgroundColor = UIColor.white
        self.dropDown?.selectionBackgroundColor = UIColor.paleGrey
        self.dropDown?.cellHeight = 60
        DropDown.appearance().setupCornerRadius(15)
        self.dropDown?.anchorView = anchorView
        self.dropDown?.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.dropDown?.setupMaskedCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner])
        self.dropDown?.animationduration = 0.25
        
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
        dateHeaderLabel.textColor = UIColor.brownishGrey
        dayHeaderLabel.textColor = UIColor.brownishGrey
        weekDayHeaderLabel.textColor = UIColor.brownishGrey
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
    
    @IBAction func testButton(_ sender: Any) {
        let noteStoryboard = UIStoryboard.init(name: "Notes", bundle : nil)
        guard let popupVC = noteStoryboard.instantiateViewController(withIdentifier: "BottomSheetVC") as? BottomSheetVC else { return }
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        //popupVC.delegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    
    @IBAction func alertTabButton(_ sender: Any) {
        let alertStoryboard = UIStoryboard.init(name: "Alert", bundle : nil)
        let uvc = alertStoryboard.instantiateViewController(withIdentifier: "AlertServiceVC")
        uvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(uvc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
    }
    
}

extension CalendarVC {
    func setupViewControllerUI() {
        
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
        //monthHeaderLabel.text = String("\(presentMonthIndex+1)월")
        self.view.sendSubviewToBack(calendarView)
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex+1)-01".date?.firstDayOfTheMonth.weekday)!
        return day
    }
    
    func getLastWeekDay() -> Int {
        let lastDay = ("\(currentYear)-\(currentMonthIndex+1)-01".date?.lastDayOfTheMonth.weekday)!
        return lastDay
    }
    
    
}


extension CalendarVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 날짜 뷰
        if collectionView == self.dateCollectionView {
            // 위 아래 빈 셀들을 위해서
            //let count = numOfDaysInMonth[currentMonthIndex] + firstWeekDayOfMonth + 8
            return 42
        } else {
            // 해당 날짜에 수업이 없을 시 수업 추가 셀 리턴
            if classDateList.count == 0 {
                return 1
            } else {
                return classDateList.count
            }
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let calendarCell = CalendarCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        let tutorInfoCell = TutorCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        let tutorBlankCell = TutorBlankCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        let currentMonthCalendarIndex = currentMonthIndex + 1
        let currentDateCalendarIndex = todaysDate
        
        
        // CalendarCollectionView
        if collectionView == self.dateCollectionView {
            // 다음 달로 넘어가면 선택한 날짜 색 초기화
            calendarCell.dateView.backgroundColor = UIColor.white
            
            // 이전 달 cell 표시
            if indexPath.item <= firstWeekDayOfMonth - 2 {
                calendarCell.isHidden = false
                calendarCell.dateLabel.textColor = UIColor.veryLightPinkThree
                // 년도 전환 시
                if currentMonthIndex == 0 {
                    let prevDate = indexPath.row - firstWeekDayOfMonth + (numOfDaysInMonth[11] + 2)
                    calendarCell.dateLabel.text="\(prevDate)"
                    calendarCell.isUserInteractionEnabled = false
                    calendarCell.image1.image = nil
                    calendarCell.image2.image = nil
                    calendarCell.image3.image = nil
                } else {
                    let prevDate = indexPath.row - firstWeekDayOfMonth + (numOfDaysInMonth[currentMonthIndex - 1] + 2)
                    calendarCell.dateLabel.text="\(prevDate)"
                    calendarCell.isUserInteractionEnabled = false
                    calendarCell.image1.image = nil
                    calendarCell.image2.image = nil
                    calendarCell.image3.image = nil
                }
                
            
                return calendarCell
            } // 이후 달 cell 표시
            else if indexPath.item >= firstWeekDayOfMonth + (numOfDaysInMonth[currentMonthIndex]-1) {
                
                calendarCell.dateLabel.textColor = UIColor.veryLightPinkThree
                calendarCell.image1.image = nil
                calendarCell.image2.image = nil
                calendarCell.image3.image = nil
                
                // 셀이 그 배열의 달 날짜 일수와 레이블이 일치하면 그 자리의 인덱스 리턴
                // 그 인덱스 + 1 인 자리부터 1++ 해주기
                // 캘린더가 옆으로 넘어갈때, 서버에서 한번 reloadData 될때 0으로 리셋해주기
                nextDate += 1
                calendarCell.dateLabel.text = "\(nextDate)"
                calendarCell.isUserInteractionEnabled = false
                return calendarCell
            } // 이번달 표시
            else {
                let calcDate = indexPath.row - firstWeekDayOfMonth+2
                calendarCell.isHidden = false
                calendarCell.dateLabel.textColor = UIColor.black
                calendarCell.dateLabel.text="\(calcDate)"
                calendarCell.dateLabel.textColor = UIColor.black
                calendarCell.isUserInteractionEnabled = true
                calendarCell.backgroundColor = UIColor.white
                calendarCell.image1.image = nil
                calendarCell.image2.image = nil
                calendarCell.image3.image = nil
                
                // sunday red tint
                if indexPath == [0,7] || indexPath == [0,14] || indexPath == [0,28] || indexPath == [0,0] || indexPath == [0,35] || indexPath == [0,21] {
                    calendarCell.dateLabel.textColor = UIColor.grapefruit
                }
                
                // 오늘 날짜인 셀 찾아서 셀렉해놓기
                if String(currentDateCalendarIndex) == calendarCell.dateLabel.text && String(currentMonthIndexConstant) == String(currentMonthIndex+1) {
                    calendarCell.dateLabel.textColor = UIColor.softBlue
                    calendarCell.dateView.backgroundColor = UIColor.white
                    calendarCell.dateLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
                    
                    // 오늘 날짜 인덱스 저장
                    self.index = indexPath
                }
                // 달력에 날짜 별 일정 점 찍기
                for i in 0..<self.classList2.count {
                    let dayMove = String(format: "%02d", arguments: [currentMonthCalendarIndex]) // with zero month
                    let todaysDate = String(format: "%02d", Int(calendarCell.dateLabel.text!)!)
                    let classDateMonthZeros = self.classList2[i].classDate.components(separatedBy: "-")[1] // with zero month
                    let classDateDay = self.classList2[i].classDate.components(separatedBy: "-")[2] // with zero day
                    // 셀의 월, 일과 일치할때 점 찍기, 아이디 넘겨주기
                    if classDateMonthZeros == dayMove && classDateDay == todaysDate {
                        let imageName = classList2[i].color
                        if calendarCell.image1.image == nil {
                            calendarCell.image1.image = UIImage(named: imageName)
                            calendarCell.classId = classList2[i].classId
                        } else if calendarCell.image2.image == nil {
                            calendarCell.image2.image = UIImage(named: imageName)
                        } else {
                            calendarCell.image3.image = UIImage(named: imageName)
                        }
                    }
                }
                
                // 점들 가운데 정렬을 위한 분기처리
//                if calendarCell.image2.image == nil && calendarCell.image3.image == nil {
//                    calendarCell.imageContainer.removeArrangedSubview(calendarCell.image3)
//                    calendarCell.imageContainer.removeArrangedSubview(calendarCell.image2)
//                }
//                else if calendarCell.image3.image == nil {
//                    calendarCell.imageContainer.removeArrangedSubview(calendarCell.image3)
//                }
                
                
                // 캘린더를 다음달로 전환 했을 때 1일 셀렉해놓기
                if currentMonthIndex != presentMonthIndex {
                    let firstWeekDayIndex  = getFirstWeekDay() - 1
                    self.dateCollectionView.selectItem(at: [0, firstWeekDayIndex], animated: true, scrollPosition: [])
                    self.collectionView(self.dateCollectionView, didSelectItemAt: [0,firstWeekDayIndex])
                } else {
                    self.dateCollectionView.selectItem(at: index, animated: true, scrollPosition: [])
                    self.collectionView(self.dateCollectionView, didSelectItemAt: index ?? [0,0])
                }
            }
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
                    //tutorInfoCell.classId = classDateList[i].classId
                }
                return tutorInfoCell
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 캘린더 컬렉션 뷰
        if collectionView == self.dateCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell
            // 날짜 선택시 셀 색깔 바뀌기
            cell?.dateView.backgroundColor = UIColor.veryLightPinkTwo
            classDateList.removeAll()
            // 오늘 날짜 선택 해놓기
            
            if indexPath == index && String(currentMonthIndexConstant) == String(currentMonthIndex+1) {
                cell?.dateLabel.textColor = UIColor.softBlue
                cell?.dateView.backgroundColor = UIColor.white
                //cell?.dateLabel.font = UIFont.boldSystemFont(ofSize: 13)
            }
            
            if let date = cell?.dateLabel.text! {
                // 날짜 선택시 헤더 날짜 레이블 바뀌기
                dateHeaderLabel.text = date
                //monthHeaderLabel.text = "\(currentMonthIndex+1)월"
                
                // 날짜별로 해당하는 수업 리턴: 선택한 날짜에 일치하는 데이터를 새로운 리스트에 append 해주기
                for index in 0..<classList2.count {
                    let dateMonthInt = currentMonthIndex + 1
                    let date2 = Int(date)
                    let dayMove = String(format: "%02d", arguments: [dateMonthInt])
                    let dayMove2 = String(format: "%02d", date2!)
                    if classList2[index].classDate == "\(currentYear)-\(dayMove)-\(dayMove2)" {
                        classDateList.append(classList2[index])
                        tutorCollectionView.reloadData()
                    }
                }
                tutorCollectionView.reloadData()
                
            }
            
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? TutorCollectionViewCell
            let calendarCell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell
            guard let receiveViewController = self.storyboard?.instantiateViewController(identifier: ClassEditVC.identifier) as? ClassEditVC else {return}
            // 과외 리스트가 있을 때에만
            if classList2.count > 0 {
                
                print("클래스 아이디", cell?.classId)
                
                // 뷰컨 ClassEditVC로 넘어가기
                receiveViewController.modalPresentationStyle = .fullScreen
                self.present(receiveViewController, animated: true, completion: nil)

                // 과외 선택시 상세 페이지 레이블 바뀌기
                if let className = cell?.classNameLabel.text! {
                    receiveViewController.classLabel.text = className
                    receiveViewController.classHeaderLabel.text = className
                }
                // CalendarView 선택된 날짜 가쟈오기
                if let date = calendarCell?.dateLabel.text! {
                    // 날짜 선택시 헤더 날짜 레이블 바뀌기
                    dateHeaderLabel.text = date
                    //monthHeaderLabel.text = "\(currentMonthIndex+1)월"
                }
                
                // 상세 페이지 과외 시작, 끝, 장소 레이블 업데이트
                if let startHour = cell?.startTimeLabel.text! {
                    //let date = calendarCell?.dateLabel.text!
                    receiveViewController.startTextField.text = "\(currentMonthIndex+1)월 \(dateHeaderLabel.text ?? "")일 \(startHour)"
                }
                
                if let endHour = cell?.endTimeLabel.text! {
                    receiveViewController.endTextField.text = "\(currentMonthIndex+1)월 \(dateHeaderLabel.text ?? "")일 \(endHour)"
                }
                
                if let location = cell?.locationLabel.text! {
                    receiveViewController.locationTextField.text = location
                }
                
                if let imageIcon = cell?.colorImage.image {
                    receiveViewController.classImage.image = imageIcon
                }
                
                if let classId = cell?.classId {
                    receiveViewController.classId = classId
                }
                
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell
        
        // 다른 날짜 선택 시 다시 색 원래대로 바뀌기: 오늘 날짜일때는 다시 보라색으로 돌아오기
        if indexPath == index && String(currentMonthIndexConstant) == String(currentMonthIndex+1) {
            cell?.dateView.backgroundColor = UIColor.white
            cell?.dateLabel.textColor = UIColor.softBlue
            classDateList.removeAll()
        } else {
            cell?.dateView.backgroundColor = UIColor.white
            classDateList.removeAll()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.dateCollectionView {
            return CGSize(width: collectionView.frame.width/7.5 , height: collectionView.frame.width/8.5 )
        } else {
            if classList2.count > 0 {
                return CGSize(width: collectionView.frame.width , height: 115 )
            } else {
                return CGSize(width: collectionView.frame.width , height: 300 )
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

