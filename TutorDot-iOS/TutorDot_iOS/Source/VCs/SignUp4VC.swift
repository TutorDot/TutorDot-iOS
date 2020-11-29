//
//  SignUp4VC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/10.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class SignUp4VC: UIViewController, UIGestureRecognizerDelegate {
    static let identifier: String = "SignUp4VC"
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordReTextfield: UITextField!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var numberlabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var correctLabel: UILabel!
    
    var finalRole: String!
    var role : String!
    var name: String?
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        initGestureRecognizer()
        self.finalRole = role
        correctLabel.isHidden = true
    }
    
    @IBAction func backButtonSelected(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) { //
        registerForKeyboardNotifications()
    }
    
    @IBAction func textFieldTapped(_ sender: Any) {
        if passwordReTextfield.text != passwordTextfield.text {
            correctLabel.isHidden = false
        }
    }

    
    @IBAction func textFieldInput(_ sender: Any) {
        if passwordReTextfield.text == passwordTextfield.text && passwordReTextfield.text?.length == passwordTextfield.text?.length{
            correctLabel.isHidden = true
        } else {
            correctLabel.isHidden = false
        }
    }
    
    func setUpViews() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: passwordTextfield.frame.size.height - 1, width: passwordTextfield.frame.size.width, height: 0.8);
        bottomBorder.backgroundColor = UIColor.veryLightPink.cgColor
        passwordTextfield.layer.addSublayer(bottomBorder)
        
        let bottomBorder2 = CALayer()
        bottomBorder2.frame = CGRect(x: 0.0, y: passwordReTextfield.frame.size.height - 1, width: passwordReTextfield.frame.size.width, height: 0.8);
        bottomBorder2.backgroundColor = UIColor.veryLightPink.cgColor
        passwordReTextfield.layer.addSublayer(bottomBorder2)
        
        serviceLabel.textColor = UIColor.brownishGrey
        numberlabel.textColor = UIColor.brownishGrey
        signUpButton.layer.cornerRadius = 10
        signUpButton.backgroundColor = UIColor.softBlue
        
    }
    
    // 회원가입 서버통신
    @IBAction func signUpSelected(_ sender: Any) {
        // 회원가입 통신
        let inputName = name
        let inputEmail = id
        let inputPw = passwordTextfield.text
        let inputRole = finalRole
        if passwordTextfield.text!.isEmpty {
            let alert = UIAlertController(title: nil, message: "비밀번호를 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            SignUpService.shared.signup(userName: inputName ?? "", email: inputEmail ?? "", password: inputPw ?? "", role: inputRole! ) { networkResult in
                switch networkResult {
                case .success:
                    // 회원가입에 성공했을때
                    print("success")
                    
                    guard let receiveViewController = self.storyboard?.instantiateViewController(withIdentifier: SignUpDoneVC.identifier) as? SignUpDoneVC else {return}
                    receiveViewController.name = self.name
                    receiveViewController.userId = self.id
                    receiveViewController.password = self.passwordTextfield.text
                    receiveViewController.role = self.finalRole
                    self.navigationController?.pushViewController(receiveViewController, animated: true)
                case .requestErr(let message):
                    guard let message = message as? String else { return }
                    let alertViewController = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                    alertViewController.addAction(action)
                    self.present(alertViewController, animated: true, completion: nil)
                    
                case .pathErr: print("path")
                case .serverErr: print("serverErr")
                case .networkFail: print("networkFail") }
            }
            
        }
        
    }
    
    // 탭했을 때 키보드 action
    func initGestureRecognizer() { //
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        self.view.addGestureRecognizer(textFieldTap)
    }
    
    //다른 위치 탭했을 때 키보드 없어지는 코드
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) { //
        self.passwordTextfield.resignFirstResponder()
        self.passwordReTextfield.resignFirstResponder()
        
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
