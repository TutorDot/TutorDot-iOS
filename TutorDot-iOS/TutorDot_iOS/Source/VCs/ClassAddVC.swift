//
//  ClassAddVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 04/07/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//
import UIKit
import DropDown

class ClassAddVC: UIViewController, UIGestureRecognizerDelegate {
    
    static let identifier: String = "ClassAddVC"
    
    @IBOutlet weak var headerViewHeightConstraints: NSLayoutConstraint!
    
    let pickerViewStart = UIPickerView()
    let pickerViewEnd = UIPickerView()
    let toolbar = UIToolbar()
    let toolbar2 = UIToolbar()
    let weekdays: [String] = ["20년 12월", "21년 1월", "21년 2월", "21년 3월", "21년 4월", "21년 5월", "21년 6월", "21년 7월", "21년 8월", "21년 9월", "21년 10월", "21년 11월", "21년 12월", "22년 1월", "22년 2월", "22년 3월", "22년 4월", "22년 5월", "22년 6월", "22년 7월", "22년 8월", "22년 9월", "22년 10월", "22년 11월", "22년 12월"]
    let startHours: [String] = ["01일", "02일", "03일", "04일", "05일", "06일","07일", "08일", "09일", "10일", "11일", "12일", "13일", "14일", "15일", "16일", "17일", "18일", "19일", "20일", "21일", "22일", "23일", "24일", "25일", "26일", "27일", "28일", "29일","30일","31일"]
    let startMins: [String] = ["00", "01", "02", "03", "04", "05", "06","07", "08", "09", "10", "11", "12"]
    let endHours: [String] =  ["00","30"]
    var ampm: [String] = ["am", "pm"]
    
    var classStartDate: String?
    var classStartTime: String?
    var classEndDate: String?
    var classEndTime: String?
    
    var days: String = ""
    var startH: String = ""
    var startM: String = ""
    var endH: String = ""
    var endM: String = ""
    var dic : [String: Int] = [:]
    var ampm1: String = ""
    var ampm2: String = ""
    var dropDown:DropDown?
    var selectionIndex: Int?
    var classLid : [Int] = []
    var classLidColor : [String] = []
    public var startTime: String = ""
    public var endTime: String = ""
    var lectureId: Int!
    
    // DropDown Setup
    @IBOutlet weak var classInfoButton: UIButton!
    @IBOutlet weak var classInfoImage:UIImageView!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var anchorView: UIView!
    // 레이블
    @IBOutlet weak var classStartLabel: UILabel!
    @IBOutlet weak var classEndLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    // PickerView Setup
    @IBOutlet weak var pickLabel: UITextField!
    @IBOutlet weak var pickLabel2: UITextField!
    @IBOutlet weak var locationTexField: UITextField!
    @IBOutlet weak var startTimeToClassLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var classNametoHeaderConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var alertView: UIView!
    
    func setTimeZone() {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimeZone()
        setUpView()
        initGestureRecognizer()
        pickerViewStart.delegate = self
        pickerViewStart.dataSource = self
        pickerViewEnd.delegate = self
        pickerViewEnd.dataSource = self
        createDatePicker()
        createDatePicker2()
        pickerViewStart.tag = 0
        pickerViewEnd.tag = 1
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCrossDissolve, animations: {
            
            self.alertView.isHidden = false
            
           
        })
        
    }

    
    override func viewWillAppear(_ animated: Bool) { //
        registerForKeyboardNotifications()
        setListDropDown()
        
    }
    
    func setUpView() {
        headerViewHeightConstraints.constant = view.frame.height * (94/812)
        pickLabel.backgroundColor = UIColor.paleGrey
        pickLabel2.backgroundColor = UIColor.paleGrey
        locationTexField.backgroundColor = UIColor.paleGrey
        pickLabel.addLeftPadding()
        pickLabel2.addLeftPadding()
        locationTexField.addLeftPadding()
        classStartLabel.textColor = UIColor.blackTwo
        classEndLabel.textColor = UIColor.blackTwo
        locationLabel.textColor = UIColor.blackTwo
        anchorView.frame.size.width = self.view.frame.size.width / 1.2
        //alertView.backgroundColor = UIColor.softBlue
        //alertView.layer.cornerRadius = 20
        
    }
    
    // 수정 반영 버튼: 서버 통신
    @IBAction func editButtonSelected(_ sender: Any) {
        // 데이터 추가하기
        
        // 위치 정보 비어있을 경우
        if locationTexField.text!.isEmpty {
            let alert = UIAlertController(title: "일정추가 실패", message: "일정 정보를 모두 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            addClassSchedule()
            
            // **서버 리로드 필요
        }
    }
    
    // 수정 취소 버튼
    @IBAction func cancelButtonSelected(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // POST : 수업 일정 추가
    func addClassSchedule() {
        guard let inputStartTime = classStartTime else { return }
        guard let inputEndTime = classEndTime else { return }
        guard let inputLocation = locationTexField.text else { return }
        guard let inputDate =  classStartDate else {return}
        guard let inputLectureId = lectureId else { return }
        ClassInfoService.classInfoServiceShared.addClassSchedule(lectureId: inputLectureId, date: inputDate, startTime: inputStartTime, endTime: inputEndTime, location: inputLocation) {
            networkResult in
            switch networkResult {
            case .success(let token):
                print("일정추가 서버 연결 성공")
                self.dismiss(animated: true, completion: nil)
                guard let token = token as? String else { return }
                UserDefaults.standard.set(token, forKey: "token")
                
            // 일정추가 실패시 AlertViewcon 열기
            case .requestErr(let message):
                guard let message = message as? String else { return }
                let alertViewController = UIAlertController(title: "일정추가 실패", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertViewController.addAction(action)
                self.present(alertViewController, animated: true, completion: nil)
            case .pathErr: print("path")
            case .serverErr: print("serverErr") case .networkFail: print("networkFail")
                
            }
        }
    }

    
    func setTextField(){
        pickLabel.layer.cornerRadius = 5
        pickLabel.placeholder = "월요일 01:00pm ~ 03:00pm"
        pickLabel.addLeftPadding()
        
    }
    
    
    func setListDropDown(){
        var dropList : [String] = []
        var classColorLid : [String] = []
        
        classInfoButton.setTitle("수업을 선택하세요", for: .normal)
        dropDown = DropDown()
        // 드랍다운 디자인
        self.dropDown?.anchorView = anchorView
        self.dropDown?.width = self.view.frame.width
        self.dropDown?.backgroundColor = UIColor.white
        self.dropDown?.selectionBackgroundColor = UIColor.paleGrey
        self.dropDown?.cellHeight = 60
        DropDown.appearance().setupCornerRadius(15)
        self.dropDown?.anchorView = anchorView
        self.dropDown?.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.dropDown?.setupMaskedCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner])
        self.dropDown?.animationduration = 0.25
        
        
        // 서버통신: 토글에 수업리스트 가져오기
        ProfileService.ProfileServiceShared.getClassLid() { networkResult in
            switch networkResult {
            case .success(let resultData):
                guard let data = resultData as? [LidToggleData] else { return print(Error.self) }
                for index in 0..<data.count {
                    let item = LidToggleData(lectureId: data[index].lectureId, lectureName: data[index].lectureName, color: data[index].color, profileUrls: data[index].profileUrls, schedules: data[index].schedules)
                    dropList.append(item.lectureName)
                    self.classLid.append(item.lectureId)
                    classColorLid.append(item.color)
                    self.dic.updateValue(self.classLid[index] , forKey: dropList[index])
                    self.dropDown?.dataSource = dropList
                
                }
                
            case .pathErr : print("Patherr")
            case .serverErr : print("ServerErr")
            case .requestErr(let message) : print(message)
            case .networkFail:
                print("networkFail")
            }
        }
        
        // 드롭박스 목록 내역
        dropDown?.dataSource = []
        dropDownButton.addTarget(self, action: #selector(dropDownToggleButton), for: .touchUpInside)
        
        // Action triggered on selection
        dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.classInfoButton.setTitle(item, for: .normal)
            self.classInfoButton.image(for: .normal)
            selectionIndex = index
            self.classInfoImage.image = UIImage(named:classColorLid[selectionIndex ?? 0])
            self.lectureId = classLid[selectionIndex ?? 0]
            
        }
        
        
        // 드롭박스 내 text 가운데 정렬
        dropDown?.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            // Setup your custom UI components
            cell.optionLabel.textAlignment = .center
        }
    }
    
    @objc func dropDownToggleButton(){
        dropDown?.show()
    }
    
    
    // 탭했을 때 키보드 action
    func initGestureRecognizer() { //
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        self.view.addGestureRecognizer(textFieldTap)
    }
    
    // 다른 위치 탭했을 때 키보드 없어지는 코드
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) { //
        self.locationTexField.resignFirstResponder()
        
    }
    
    func registerForKeyboardNotifications() { //
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드가 생길 떄 텍스트 필드 위로 밀기
    @objc func keyboardWillShow(_ notification: NSNotification) { //
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight: CGFloat // 키보드의 높이
        
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            
            self.classInfoButton.alpha = 0
            self.classInfoImage.alpha = 0
            self.dropDownButton.alpha = 0
            
            // +로 갈수록 y값이 내려가고 -로 갈수록 y값이 올라간다.
            self.classNametoHeaderConstraint.constant = 0
            self.startTimeToClassLabelConstraint.constant = 0
        })
        
        self.view.layoutIfNeeded()
    }
    
    // 키보드가 사라질 때 어떤 동작을 수행
    @objc func keyboardWillHide(_ notification: NSNotification) { //
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            
            // 원래대로 돌아가도록
            self.classInfoButton.alpha = 1.0
            self.classInfoImage.alpha = 1.0
            self.dropDownButton.alpha = 1.0
            self.classNametoHeaderConstraint.constant = 30
            self.startTimeToClassLabelConstraint.constant = 25
        })
        
        self.view.layoutIfNeeded()
    }
    
}

extension ClassAddVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func createDatePicker(){
        toolbar.sizeToFit()
        var buttons = [UIBarButtonItem]()
        
        let doneButton = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed))
        let cancelButton = UIBarButtonItem(title: "취소", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.cancelPressed))
        let titleBar = UIBarButtonItem(title: "시간 선택", style: UIBarButtonItem.Style.done, target: nil, action: nil)
        let space1 =  UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let space2 =  UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //toolbar button color 설정
        titleBar.isEnabled = false
        titleBar.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.dark], for: .disabled)
        cancelButton.tintColor = UIColor.softBlue
        doneButton.tintColor = UIColor.softBlue
        
        //toolbar에 버튼 넣기
        buttons = [cancelButton, space1, titleBar, space2, doneButton]
        toolbar.setItems(buttons, animated: true)
        pickLabel.inputAccessoryView = toolbar
        pickLabel.inputView = pickerViewStart
        
    }
    
    func createDatePicker2(){
        toolbar2.sizeToFit()
        var buttons = [UIBarButtonItem]()
        let doneButton = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed2))
        let cancelButton = UIBarButtonItem(title: "취소", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.cancelPressed))
        let titleBar = UIBarButtonItem(title: "시간 선택", style: UIBarButtonItem.Style.done, target: nil, action: nil)
        let space1 =  UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let space2 =  UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //toolbar button color 설정
        titleBar.isEnabled = false
        titleBar.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.dark], for: .disabled)
        cancelButton.tintColor = UIColor.softBlue
        doneButton.tintColor = UIColor.softBlue
        
        //toolbar에 버튼 넣기
        buttons = [cancelButton, space1, titleBar, space2, doneButton]
        toolbar2.setItems(buttons, animated: true)
        pickLabel2.inputAccessoryView = toolbar2
        pickLabel2.inputView = pickerViewEnd
        
    }
    
    //toolbar actions
    @objc func donePressed() {
        let dateRaw = pickLabel.text?.components(separatedBy: "일")[0] // 시작 날짜
        let dateRawTime = pickLabel.text?.components(separatedBy: "일")[1] ?? "00:00"  // 시작 시간
        let dateRawTimeStart = dateRawTime.components(separatedBy: " ")[1] // 시작 시간 스페이스바 제외
        classStartTime = dateRawTimeStart
        let inputYear = dateRaw?.components(separatedBy: "년")[0] ?? "21"
        let inputMonth = dateRaw?.components(separatedBy: "월")[0]
        let dateSpaceEnd = dateRaw?.components(separatedBy:"월")[1]
        let inputMonthSplitEnd = inputMonth?.components(separatedBy: "년")[1]
        let inputDateEnd : String? = dateSpaceEnd?.components(separatedBy:" ")[1]
        let inputMonthEnd = inputMonthSplitEnd?.components(separatedBy: " ")[1]
        //print(inputMonthSplitEnd, inputMonth, inputMonthSplitEnd)
        if inputMonthEnd!.count == 1 {
            let classEndD: String? = "20" + inputYear + "-0" + inputMonthEnd! + "-" + inputDateEnd!
            classStartDate = classEndD
        } else {
            let classEndD: String? = "20" + inputYear + "-" + inputMonthEnd! + "-" + inputDateEnd!
            classStartDate = classEndD
        }
        print(classStartDate, classStartTime)
        self.view.endEditing(true)
    }
    
    @objc func donePressed2() {
        let dateRaw2 = pickLabel2.text?.components(separatedBy: "일")[0] // 시작 날짜
        let dateRawTime2 = pickLabel2.text?.components(separatedBy: "일")[1] ?? "00:00"  // 시작 시간
        let dateRawTimeStart2 = dateRawTime2.components(separatedBy: " ")[1] // 시작 시간 스페이스바 제외
        classEndTime = dateRawTimeStart2
        //print(classEndTime)
        let inputYear2 = dateRaw2?.components(separatedBy: "년")[0] ?? "21"
        let inputMonth2 = dateRaw2?.components(separatedBy: "월")[0]
        let dateSpaceEnd2 = dateRaw2?.components(separatedBy:"월")[1]
        let inputMonthSplitEnd2 = inputMonth2?.components(separatedBy: "년")[1]
        let inputDateEnd2 : String? = dateSpaceEnd2?.components(separatedBy:" ")[1]
        let inputMonthEnd2 = inputMonthSplitEnd2?.components(separatedBy: " ")[1]
        //print(inputMonthSplitEnd2, inputMonth2, inputMonthSplitEnd2)
        if inputMonthEnd2!.count == 1 {
            let classEndD: String? = "20" + inputYear2 + "-0" + inputMonthEnd2! + "-" + inputDateEnd2!
            classEndDate = classEndD
        } else {
            let classEndD: String? = "20" + inputYear2 + "-" + inputMonthEnd2! + "-" + inputDateEnd2!
            classEndDate = classEndD
        }
        print(classEndDate, classEndTime)
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0  {
            switch component {
            case 0:
                return weekdays.count
            case 1:
                return startHours.count
            case 2:
                return startMins.count
            case 3:
                return endHours.count
            case 4:
                return ampm.count
            default:
                return 1
            }
        } else {
            switch component {
            case 0:
                return weekdays.count
            case 1:
                return startHours.count
            case 2:
                return startMins.count
            case 3:
                return endHours.count
            case 4:
                return ampm.count
            default:
                return 1
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            switch component {
            case 0:
                return weekdays[row]
            case 1:
                return startHours[row]
            case 2:
                return startMins[row]
            case 3:
                return endHours[row]
            case 4:
                return ampm[row]
                
            default:
                return ""
            }
        } else if pickerView.tag == 1 {
            switch component {
            case 0:
                return weekdays[row]
            case 1:
                return startHours[row]
            case 2:
                return startMins[row]
            case 3:
                return endHours[row]
            case 4:
                return ampm[row]
                
            default:
                return ""
            }
            
        }
        return ""
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
            var startrow: Int = 0
            
            days = weekdays[pickerView.selectedRow(inComponent: 0)]
            
            if startHours[pickerView.selectedRow(inComponent: 1)] != "00" {
                startH = startHours[pickerView.selectedRow(inComponent: 1)]
                startrow = row
                pickerView.selectRow(startrow, inComponent: 3, animated: true)
                endH = endHours[pickerView.selectedRow(inComponent: 3)]
            }
            
            startM = startMins[pickerView.selectedRow(inComponent: 2)]
            endH = endHours[pickerView.selectedRow(inComponent: 3)]
            ampm1 = ampm[pickerView.selectedRow(inComponent:4)]
            
            
            if days == "" {
                days = weekdays[0]
            } else if startH == "" {
                startH = startHours[0]
            } else if startM == "" {
                startM = startMins[0]
            } else if endH == "" {
                endH = endHours[0]
            } else if ampm1 == "" {
                ampm1 = ampm[0]
            }
            
            pickLabel.text = days + " " + startH + " " + startM + ":" + endH + ampm1
            
        } else {
            var startrow: Int = 0
            
            days = weekdays[pickerViewEnd.selectedRow(inComponent: 0)]
            
            if startHours[pickerViewEnd.selectedRow(inComponent: 1)] != "00" {
                startH = startHours[pickerViewEnd.selectedRow(inComponent: 1)]
                startrow = row
                pickerViewEnd.selectRow(startrow, inComponent: 3, animated: true)
                endH = endHours[pickerViewEnd.selectedRow(inComponent: 3)]
            }
            
            
            startM = startMins[pickerViewEnd.selectedRow(inComponent: 2)]
            endH = endHours[pickerViewEnd.selectedRow(inComponent: 3)]
            
            if days == "" {
                days = weekdays[0]
            } else if startH == "" {
                startH = startHours[0]
            } else if startM == "" {
                startM = startMins[0]
            } else if endH == "" {
                endH = endHours[0]
            } else if ampm1 == "" {
                ampm1 = ampm[0]
            }
            
            pickLabel2.text = days + " " + startH + " " + startM + ":" + endH + ampm1
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 110
        case 1:
            return 60
        case 2:
            return 40
        case 3:
            return 40
        case 4:
            return 50
        default:
            return 1
        }
    }
    
}
