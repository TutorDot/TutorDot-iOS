//
//  passwordModifyVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/27.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class passwordModifyVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newpasswordTextField: UITextField!
    @IBOutlet weak var newpasswordCheckTextField: UITextField!
    
    @IBOutlet weak var ModifyButton: UIButton!
    
    @IBOutlet weak var correctLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ModifyButton.layer.cornerRadius = 8
        correctLabel.isHidden = true
        initGestureRecognizer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func idDeleteButtonDidTap(_ sender: Any) {
        idTextField.text = ""
    }
    
    @IBAction func passwordDelButtonDidTap(_ sender: Any) {
        passwordTextField.text = ""
    }
    
    @IBAction func newPwDelButtonDidTap(_ sender: Any) {
        newpasswordTextField.text = ""
    }
    
    @IBAction func newPwCheckDelButtonDidTap(_ sender: Any) {
        newpasswordCheckTextField.text = ""
    }
    
    @IBAction func comparePassword(_ sender: Any) {
        if newpasswordCheckTextField.text == newpasswordTextField.text && newpasswordCheckTextField.text?.length == newpasswordTextField.text?.length{
            correctLabel.isHidden = true
        } else {
            correctLabel.isHidden = false
        }
    }
    
    @IBAction func changePassword(_ sender: Any) {
        guard let inputID = idTextField.text else { return }
        guard let inputPw = newpasswordTextField.text else { return }
        print(inputID, inputPw, "비번")
        
        ProfileService.ProfileServiceShared.changePassword(email: inputID, newPassword: inputPw) { networkResult in switch networkResult {
        case .success(_):
            // 자동로그인이 선택되어 있으면 id,pwd를 공유객체에 저장함
            let alertViewController = UIAlertController(title: "비밀번호 변경 성공", message: "비밀번호가 변경되었습니다", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
        case .requestErr(let message):
            guard let message = message as? String else { return }
            let alertViewController = UIAlertController(title: "비밀번호 변경 실패", message: "아이디 혹은 비밀번호를 확인해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
            print("requestErr")
        case .pathErr:
            let alertViewController = UIAlertController(title: "비밀번호 변경 실패", message: "아이디 혹은 비밀번호를 확인해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
            print("pathErr")
        case .serverErr: print("serverErr")
        case .networkFail: print("networkFail") }
        }
}
    
    func initGestureRecognizer() { //
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        self.view.addGestureRecognizer(textFieldTap)
    }
    
    // 다른 위치 탭했을 때 키보드 없어지는 코드
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) { //
        self.idTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.newpasswordTextField.resignFirstResponder()
        self.newpasswordCheckTextField.resignFirstResponder()
        
        
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
            
//            self.classInfoButton.alpha = 0
//            self.classInfoImage.alpha = 0
//            self.dropDownButton.alpha = 0
//
//            // +로 갈수록 y값이 내려가고 -로 갈수록 y값이 올라간다.
//            self.classNametoHeaderConstraint.constant = 0
//            self.startTimeToClassLabelConstraint.constant = 0
        })
        
        self.view.layoutIfNeeded()
    }
    
    // 키보드가 사라질 때 어떤 동작을 수행
    @objc func keyboardWillHide(_ notification: NSNotification) { //
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            
            // 원래대로 돌아가도록
//            self.classInfoButton.alpha = 1.0
//            self.classInfoImage.alpha = 1.0
//            self.dropDownButton.alpha = 1.0
//            self.classNametoHeaderConstraint.constant = 30
//            self.startTimeToClassLabelConstraint.constant = 25
        })
        
        self.view.layoutIfNeeded()
    }
}
