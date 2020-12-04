//
//  AddRegularClassTimeCell.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/15.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

protocol TimeSendDelegate: class {
    func classTimesend(_ days: String, _ startTime: String, _ endTime: String, _ index: Int)

}

class AddRegularClassTimeCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    static let identifier: String = "AddRegularClassTimeCell"
    var delegate: TimeSendDelegate?
    
    @IBOutlet weak var classTimes: UITextField!
    
    let pickerView = UIPickerView()
    let toolbar = UIToolbar()
    let weekdays: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    let startHours: [String] = ["00", "01", "02", "03", "04", "05", "06","07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    let startMins: [String] = ["00","30"]
    let endHours: [String] = ["00", "01", "02", "03", "04", "05", "06","07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    let endMins: [String] = ["00","30"]
    var index: Int = 0 //해당 셀의 인덱스
    
    //서버로 넘기고 + 텍스트 창에 띄울 String
    public var days: String = ""
    var startH: String = ""
    var startM: String = ""
    var endH: String = ""
    var endM: String = ""
    var ampm1: String = ""
    var ampm2: String = ""
    public var startTime: String = ""
    public var endTime: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createDatePicker()
        pickerView.delegate = self
        pickerView.dataSource = self
    }



        
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
        
        
        classTimes.inputAccessoryView = toolbar
        classTimes.inputView = pickerView
        
    }
    
    
    @IBAction func timeFieldEndEditing(_ sender: Any) {
        if let delegate = delegate {
                delegate.classTimesend(days, startTime, endTime, index)
        }
    }
    
  
    
    //toolbar actions
    @objc func donePressed(){
        self.endEditing(true)
    }
    @objc func cancelPressed(){
        self.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

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
            return endMins.count

        default:
            return 1
        }
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        
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
            return endMins[row]
        default:
            return ""
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        days = weekdays[pickerView.selectedRow(inComponent: 0)]
        
        //시작 시간을 선택했으면 끝나는 시간도 똑같이 셋팅해주기 (사용자 편의)
        if component == 1 && startHours[pickerView.selectedRow(inComponent: 1)] != "00" {
            
            pickerView.selectRow(row, inComponent: 3, animated: true)

        }
        
        startH = startHours[pickerView.selectedRow(inComponent: 1)]
        startM = startMins[pickerView.selectedRow(inComponent: 2)]
        endH = endHours[pickerView.selectedRow(inComponent: 3)]
        endM = endMins[pickerView.selectedRow(inComponent: 4)]
       
        
        if days == "" {
            days = weekdays[0]
        } else if startH == "" {
            startH = startHours[0]
        } else if startM == "" {
            startM = startMins[0]
        } else if endH == "" {
            endH = endHours[0]
        } else if endM == "" {
            endM = endMins[0]
        }
        
        // pm과 am으로 구분하기
        // 00~12 -> 시간 그대로, 13~23 -> 시간 1-11까지 쓰기
        // 00~11 -> am, 12~23 -> pm
        
        // starttime 가공
        if Int(startH)! >= 0 && Int(startH)! < 12 {
            ampm1 = "am"
        } else if Int(startH)! > 12 && Int(startH)! < 24 {
            ampm1 = "pm"
        }
        
        // endtime 가공
        if Int(endH)! >= 0 && Int(endH)! < 12 {
            ampm2 = "am"
        } else if Int((endH))! > 12 && Int((endH))! < 24 {
            ampm2 = "pm"
        }
        
        // 13~23시 가공
        if Int(startH)! > 12 {
            let newStartH: Int = Int(startH)! - 12
            startH = String(newStartH)
            if startH.count < 2 {
                startH = "0" + startH
            }
        }
        
        // 13~23시 가공
        if Int(endH)! > 12 {
            let newEndH: Int = Int(endH)! - 12
            endH = String(newEndH)
            if endH.count < 2 {
                endH = "0" + endH
            }
        }
        
        // 최종 시간 format 맞추기
        startTime = startH + ":" + startM + ampm1
        endTime = endH + ":" + endM + ampm2
        classTimes.text = days + " " + startTime + " ~ " + endTime
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
         switch component {
           case 0:
               return 70
           case 1:
               return 50
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
