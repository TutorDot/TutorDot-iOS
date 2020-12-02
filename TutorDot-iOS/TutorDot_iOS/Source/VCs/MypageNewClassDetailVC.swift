//
//  MypageNewClassDetailVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/26.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os


class MypageNewClassDetailVC: UIViewController, UITextFieldDelegate {

    static let identifier: String = "MypageNewClassDetailVC"
    
    //현재 뷰에서 다음 뷰로 전달할 내용
    var className: String = ""
    var classColor: String = ""
    var timeValue: Int? = 0
    var priceValue: Int? = 0
    @IBOutlet weak var bank: UITextField!
    @IBOutlet weak var bankAccount: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var price: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardType()
        
        bankAccount.delegate = self
        bank.delegate = self
        price.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -80 // Move view 80 points upward
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0// Move view 80 points upward
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        bankAccount.resignFirstResponder()
        bank.resignFirstResponder()
        price.resignFirstResponder()
        return true

    }

    
    func setKeyboardType(){
        time.keyboardType = .numberPad
        price.keyboardType = .numberPad
        bank.keyboardType = .default
        bankAccount.keyboardType = .phonePad
    }
    
    
    @IBAction func timeEndEditing(_ sender: Any) {
        if time.text != "" {
            timeValue = Int(time.text ?? "0")
            time.text = String(timeValue ?? 00) + "  시간"
        }
    }
    
    @IBAction func priceEndEditing(_ sender: Any) {
        if price.text != "" {
            priceValue = Int(price.text ?? "0")
            price.text = String(priceValue ?? 00) + "  만원"
        }
    }
    
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func timeDelButtonDidTap(_ sender: Any) {
        time.text = ""
    }
    
    @IBAction func priceDelButtonDidTap(_ sender: Any) {
        price.text = ""
    }
    
    @IBAction func bankDelButtonDidTap(_ sender: Any) {
        bank.text = ""
        bankAccount.text = ""
    }
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        
        print("hihi", bank.text, " ", bankAccount.text, " ", timeValue)
        
        if bank.text == "" || bankAccount.text == "" || timeValue == 0 || priceValue == 0 {
            
            var inputMessage: String = ""
            
            if bank.text == "" {
                inputMessage = "은행명을 입력해주세요."
            } else if bankAccount.text == "" {
                inputMessage = "계좌번호를 입력해주세요."
            } else if timeValue == 0 {
                inputMessage = "시간을 입력해주세요."
            } else if priceValue == 0 {
                inputMessage = "금액을 입력해주세요."
            }
            
            let alert = UIAlertController(title: "필요한 값이 없습니다", message: inputMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MypageNewClassTimeVC") as? MypageNewClassTimeVC else {return}
            
            nextVC.className = self.className
            nextVC.classColor = self.classColor
            nextVC.classTime = timeValue ?? 0
            nextVC.classPrice = priceValue ?? 0
            nextVC.tutorBank = bank.text ?? ""
            nextVC.tutorBanckAccout = bankAccount.text ?? ""
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    // 화면 터치 시, 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
