//
//  MypageNewClassDetailVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/26.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os


class MypageNewClassDetailVC: UIViewController {

    static let identifier: String = "MypageNewClassDetailVC"
    var className: String = ""
    var classColor: String = ""
    var timeValue: Int? = 0
    var priceValue: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardType()
        print("color = " + classColor)
        
    }
    
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var bank: UITextField!
    @IBOutlet weak var bankAccount: UITextField!
    
    func setKeyboardType(){
        time.keyboardType = .numberPad
        price.keyboardType = .numberPad
        bank.keyboardType = .default
        bankAccount.keyboardType = .phonePad
    }
    
    @IBAction func timeEndEditing(_ sender: Any) {
        timeValue = Int(time.text ?? "0")
        time.text = time.text ?? "00" + "  시간"
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
        //MyClassAddTimeVC
        let storyBoard = UIStoryboard.init(name: "MyPage", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "MyClassAddTimeVC")
        nextVC.modalPresentationStyle = .currentContext
        nextVC.modalTransitionStyle = .crossDissolve
        present(nextVC, animated: true, completion: nil)
    }
    

}
