//
//  SignUp3VC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/10.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class SignUp3VC: UIViewController, UIGestureRecognizerDelegate {
    
    static let identifier: String = "SignUp3VC"
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    var name : String?
    var receiveRole: String!
    var idChecked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        initGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) { //
        registerForKeyboardNotifications()
    }
    
    @IBAction func nextButtonSelected(_ sender: Any) {
        guard let receiveViewController = self.storyboard?.instantiateViewController(withIdentifier: SignUp4VC.identifier) as? SignUp4VC else {return}
        if idTextField.text!.isEmpty {
            let alert = UIAlertController(title: "필요한 값이 없습니다", message: "아이디를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if idChecked == false {
            let alert = UIAlertController(title: "아이디 중복 확인", message: "아이디 중복확인을 해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            receiveViewController.name = self.name
            receiveViewController.role = self.receiveRole
            receiveViewController.id = self.idTextField.text
            
            self.navigationController?.pushViewController(receiveViewController, animated: true)
        }
        
       
    }
    
    @IBAction func backButtonSelected(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func idCheckButton(_ sender: Any) {
        guard let inputID = idTextField.text else { return }
        
        LoginService.shared.idCheck(email: inputID) { networkResult in switch networkResult {
        case .success(_):
            // 자동로그인이 선택되어 있으면 id,pwd를 공유객체에 저장함
            self.idChecked = true
            let alertViewController = UIAlertController(title: "사용가능한 아이디입니다", message: "사용가능한 아이디입니다", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
        case .requestErr(let message):
            self.idChecked = false
            guard let message = message as? String else { return }
            let alertViewController = UIAlertController(title: "이미 존재하는 아이디입니다", message: "이미 존재하는 아이디입니다", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
            print("requestErr")
        case .pathErr:
            self.idChecked = false
            let alertViewController = UIAlertController(title: "이미 존재하는 아이디입니다", message: "이미 존재하는 아이디입니다", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
            print("pathErr")
        case .serverErr: print("serverErr")
        case .networkFail: print("networkFail") }
        }
        
    }
    
    
    func setUpViews() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: idTextField.frame.size.height - 1, width: idTextField.frame.size.width, height: 0.8);
        bottomBorder.backgroundColor = UIColor.veryLightPink.cgColor
        idTextField.layer.addSublayer(bottomBorder)
        serviceLabel.textColor = UIColor.brownishGrey
        numberLabel.textColor = UIColor.brownishGrey
        
    }
    
    func isValidId(id: String?) -> Bool {
        guard id != nil else { return false }
        let regEx = "[A-Za-z0-9]{5,20}"
        // 보통 아이디는 영문+숫자로 구성됨. 여기서는 5~20자 이내의 아이디 허용!
        // 만약 대문자를 빼고싶으면 "[a-z0-9]{5,20}" 로 하면된다~
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: id)
    }
    
    
    // 탭했을 때 키보드 action
    func initGestureRecognizer() { //
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        self.view.addGestureRecognizer(textFieldTap)
    }
    
    //다른 위치 탭했을 때 키보드 없어지는 코드
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) { //
        self.idTextField.resignFirstResponder()
        
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드가 생길 떄 텍스트 필드 위로 밀기
    @objc func keyboardWillShow(_ notification: NSNotification) { //
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        // animation 함수
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            
        })
        
        self.view.layoutIfNeeded()
    }
    
    // 키보드가 사라질 때 어떤 동작을 수행
    @objc func keyboardWillHide(_ notification: NSNotification) { //
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
        })
        
        self.view.layoutIfNeeded()
    }
    
    
}
