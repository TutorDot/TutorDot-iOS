//
//  ClassInfoVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 03/07/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//
import UIKit

class ClassInfoVC: UIViewController, UIGestureRecognizerDelegate {
    
    static let identifier: String = "ClassInfoVC"
    
    @IBOutlet weak var headerViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var addCancelButton: UIButton!
    var classId : Int!
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    // PickerView
    let pickerViewStart = UIPickerView()
    let pickerViewEnd = UIPickerView()
    let toolbar = UIToolbar()
    let toolbar2 = UIToolbar()
    
    let weekdays: [String] = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
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
    var ampm1: String = ""
    var ampm2: String = ""
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var startTimeToClassLabelConstraint: NSLayoutConstraint!
    
    var isOpen = false
    var editClicked = false
    
    var tutorCollectionViewCellInstance: TutorCollectionViewCell?
    var classNameHeader: String?
    var classNameBody: String = ""
    var classImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerViewHeightConstraints.constant = view.frame.height * (94/812)
        setUpView()
        initGestureRecognizer()
        pickerViewStart.delegate = self
        pickerViewStart.dataSource = self
        pickerViewEnd.delegate = self
        pickerViewEnd.dataSource = self
        createDatePicker2()
        createDatePicker()
        pickerViewStart.tag = 0
        pickerViewEnd.tag = 1
    }
    
    override func viewWillAppear(_ animated: Bool) { //
        registerForKeyboardNotifications()
    }
    
    func setUpView() {
        classLabel.text = classNameBody
        startTextField.backgroundColor = UIColor.paleGrey
        endTextField.backgroundColor = UIColor.paleGrey
        locationTextField.backgroundColor = UIColor.paleGrey
        startTextField.addLeftPadding()
        endTextField.addLeftPadding()
        locationTextField.addLeftPadding()
        startTextField.textColor = UIColor.brownishGrey
        endTextField.textColor = UIColor.brownishGrey
        locationTextField.textColor = UIColor.brownishGrey
    }
    
    // 확인 버튼 클릭시 전 뷰컨으로 돌아가기
    // 데이터 받아오기
    @IBAction func editButtonSelected(_ sender: UIButton) {
        editClassSchedule()
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: ClassEditVC.identifier) as? ClassEditVC else { return }
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
        //self.dismiss(animated: false, completion: nil)
        // 데이터 ClassEditVC에 다시 보내주기
        if let className = self.classLabel.text {
            controller.classHeaderLabel.text = className
            controller.classLabel.text = className
        }
        if let startHour = self.startTextField.text {
            controller.startTextField.text = startHour
        }
        
        if let endHour = self.endTextField.text {
            controller.endTextField.text = endHour
        }
        
        if let location = self.locationTextField.text {
            controller.locationTextField.text = location
        }
        
        if let image = self.imageLabel.image {
            controller.classImage.image = image
        }
        
    }
    
    // PUT : 수업 일정 수정
    func editClassSchedule() {
        guard let inputStartTime = classStartTime else { return }
        guard let inputEndTime = classEndTime else { return }
        guard let inputLocation = locationTextField.text else { return }
        guard let inputDate =  classStartDate else {return}
        let classIdNew = classId
        //print("확인해보기", inputStartTime, inputEndTime, inputLocation, inputDate, classIdNew)
        print("classs", classIdNew)
        
        ClassInfoService.classInfoServiceShared.editClassSchedule(classId: classId, date: inputDate, startTime: inputStartTime, endTime: inputEndTime, location: inputLocation) {
            networkResult in
            switch networkResult {
            case .success(let token):
                guard let token = token as? String else { return }
                UserDefaults.standard.set(token, forKey: "token")
                print("일정추가 수정 연결 성공")
            // 일정추가 실패시 AlertViewcon 열기
            case .requestErr(let message):
                guard let message = message as? String else { return }
                let alertViewController = UIAlertController(title: "일정수정 실패", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertViewController.addAction(action)
                self.present(alertViewController, animated: true, completion: nil)
            case .pathErr: print("path")
            case .serverErr: print("serverErr") case .networkFail: print("networkFail")
                
            }
        }
    }
    // 취소 버튼 클릭 시 ClassEditVC로 그냥 돌아오기
    @IBAction func editCancelButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // 탭했을 때 키보드 action
    func initGestureRecognizer() { //
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        self.view.addGestureRecognizer(textFieldTap)
    }
    
    // 다른 위치 탭했을 때 키보드 없어지는 코드
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) { 
        self.locationTextField.resignFirstResponder()
        
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
        
        // animation 함수
        // 최종 결과물 보여줄 상태만 선언해주면 애니메이션은 알아서
        // duration은 간격
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            
            self.classLabel.alpha = 0
            self.imageLabel.alpha = 0
            
            // +로 갈수록 y값이 내려가고 -로 갈수록 y값이 올라간다.
            self.startTimeToClassLabelConstraint.constant = 0
            self.bottomConstraint.constant = +keyboardHeight/2 + 100
        })
        
        self.view.layoutIfNeeded()
    }
    
    // 키보드가 사라질 때 어떤 동작을 수행
    @objc func keyboardWillHide(_ notification: NSNotification) { //
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            
            // 원래대로 돌아가도록
            self.classLabel.alpha = 1.0
            self.imageLabel.alpha = 1.0
            self.startTimeToClassLabelConstraint.constant = 25
            self.bottomConstraint.constant = 30
        })
        
        self.view.layoutIfNeeded()
    }
    
    
}

extension ClassInfoVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        startTextField.inputAccessoryView = toolbar
        startTextField.inputView = pickerViewStart
        
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
        endTextField.inputAccessoryView = toolbar2
        endTextField.inputView = pickerViewEnd
        
    }
    
    //toolbar actions
    @objc func donePressed(){
        let dateRaw = startTextField.text?.components(separatedBy: "일")[0]
        let dateRawTime = startTextField.text?.components(separatedBy: "일")[1] // 시작 시간
        let dateRawTimeStart = dateRawTime?.components(separatedBy: " ")[1] // 시작 시간 스페이스바 제외
        let inputMonth = dateRaw?.components(separatedBy: "월")[0]
        //print("확인", dateRaw, dateRawTime, dateRawTimeStart, inputMonth)
        classStartTime = dateRawTimeStart
        let dateSpace = dateRaw?.components(separatedBy:"월")[1]
        let inputDate:String? = dateSpace?.components(separatedBy:" ")[1]
        if inputMonth!.count == 1 {
            let classStartD: String? = "2020-0" + inputMonth! + "-" + inputDate!
            classStartDate = classStartD
        } else {
            let classStartD: String? = "2020-" + inputMonth! + "-" + inputDate!
            classStartDate = classStartD
        }
        print(classStartDate, classStartTime)
        self.view.endEditing(true)
    }
    
    @objc func donePressed2() {
        let dateRaw2 = endTextField.text?.components(separatedBy: "일")[0]
        let dateRawTime2 = endTextField.text?.components(separatedBy: "일")[1] // 시작 시간
        let dateRawTimeStart2 = dateRawTime2?.components(separatedBy: " ")[1] // 시작 시간 스페이스바 제외
        classEndTime = dateRawTimeStart2
        let inputMonth2 = dateRaw2?.components(separatedBy: "월")[0]
        let dateSpaceEnd2 = dateRaw2?.components(separatedBy:"월")[1]
        let inputDateEnd2 : String? = dateSpaceEnd2?.components(separatedBy:" ")[1]
        let inputMonthEnd2 = dateRaw2?.components(separatedBy: "월")[0]
        if inputMonth2!.count == 1 {
            let classEndD: String? = "2020-0" + inputMonthEnd2! + "-" + inputDateEnd2!
            classEndDate = classEndD
        } else {
            let classEndD: String? = "2020-" + inputMonthEnd2! + "-" + inputDateEnd2!
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
            
            startTextField.text = days + " " + startH + " " + startM + ":" + endH + ampm1
            
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
            
            endTextField.text = days + " " + startH + " " + startM + ":" + endH + ampm1
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 55
        case 1:
            return 60
        case 2:
            return 50
        case 3:
            return 50
        case 4:
            return 50
        default:
            return 1
        }
    }
    
}


