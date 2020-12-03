//
//  LoginVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 30/06/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import BEMCheckBox
import Lottie


class LoginVC: UIViewController, UIGestureRecognizerDelegate {
    static let identifier : String = "LoginVC"
    static let loginShared = LoginVC()
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var labelToLeftConstraint: NSLayoutConstraint!
    
    var emailText = ""
    var passwordText = ""
    let animationView = AnimationView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetUp()
        initGestureRecognizer()
        if self.view.frame.size.height > 850 {
            labelToLeftConstraint.constant = 100
        } else if self.view.frame.size.height == 844 && self.view.frame.size.width == 390 {
            labelToLeftConstraint.constant = 105
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) { //
        registerForKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func viewSetUp() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: emailTextField.frame.size.height - 1, width: emailTextField.frame.size.width, height: 0.8);
        bottomBorder.backgroundColor = UIColor.veryLightPink.cgColor
        emailTextField.layer.addSublayer(bottomBorder)
        
        let bottomBorder2 = CALayer()
        bottomBorder2.frame = CGRect(x: 0.0, y: passWordTextField.frame.size.height - 1, width: passWordTextField.frame.size.width, height: 0.8);
        bottomBorder2.backgroundColor = UIColor.veryLightPink.cgColor
        passWordTextField.layer.addSublayer(bottomBorder2)
        
        loginButton.backgroundColor = UIColor.softBlue
        loginButton.layer.cornerRadius = loginButton.frame.size.width/25
        
        // 이메일, 비번 받아오기
        emailTextField.text = emailText
        passWordTextField.text = passwordText
    
        
    }
    func loadingAnimation(){
            
            animationView.animation = Animation.named("final") // 로티 이름으로 애니메이션 등록
            animationView.frame = view.bounds
            print(self.view.frame.size.height / 2, "눂이")
            if self.view.frame.size.height > 700 {
                animationView.frame = CGRect(x: 0, y: self.view.frame.size.height / 2 - 100, width: animationView.frame.size.width, height: animationView.frame.size.height)
            } else {
                animationView.frame = CGRect(x: 0, y: self.view.frame.size.height / 2 - 60, width: animationView.frame.size.width, height: animationView.frame.size.height)
            }
            animationView.contentMode = .scaleAspectFill
            animationView.loopMode = .playOnce
            self.view.addSubview(animationView)
            animationView.play()
        }
        
        func loadingAnimationStop(){
            
            animationView.stop()
            animationView.removeFromSuperview()
           
    }
    
    // 탭했을 때 키보드 action
    func initGestureRecognizer() { //
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        self.view.addGestureRecognizer(textFieldTap)
    }
    
    // 다른 위치 탭했을 때 키보드 없어지는 코드
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) { //
        self.emailTextField.resignFirstResponder()
        self.passWordTextField.resignFirstResponder()
        
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
    

    
    
    @IBAction func loginButtontapped(_ sender: Any) {
        loadingAnimation()
        
        // 로그인 서비스
        guard let inputID = emailTextField.text else { return }
        guard let inputPWD = passWordTextField.text else { return }
        
        LoginService.shared.login(email: inputID, password: inputPWD) { networkResult in switch networkResult {
        case .success(let token):
            // 자동로그인이 선택되어 있으면 id,pwd를 공유객체에 저장함
            let dataSave = UserDefaults.standard // UserDefaults.standard 정의
            dataSave.setValue(inputID, forKey: "save_userNm") // save_userNm 키값에 id값 저장
            dataSave.setValue(inputPWD, forKey: "save_pw") // save_pw 키값에 pw값 저장
            UserDefaults.standard.synchronize() // setValue 실행
            
            guard let token = token as? String else { return }
            //let token = token[0]
            UserDefaults.standard.set(token, forKey: "token")
            print("myToken:",token)
            print("\(UserDefaults.standard.value(forKey: "save_userNm")!)")
            print("\(UserDefaults.standard.value(forKey: "save_pw")!)")
            // 로그인 성공시 뷰 전환
            let tabbarStoryboard = UIStoryboard.init(name: "MainTab", bundle: nil)
            guard let mainView = tabbarStoryboard.instantiateViewController(identifier:"TabbarVC") as?
                    TabbarVC else { return }
            mainView.modalPresentationStyle = .fullScreen
            self.present(mainView, animated: true, completion: nil)
            self.loadingAnimationStop()
            
        case .requestErr(let message):
            let alertViewController = UIAlertController(title: "로그인 실패", message: "아이디와 비밀번호를 확인해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
            print("requestErr")
            self.loadingAnimationStop()
        case .pathErr:
            let alertViewController = UIAlertController(title: "로그인 실패", message: "아이디와 비밀번호를 확인해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
            print("pathErr")
            self.loadingAnimationStop()
        case .serverErr: print("serverErr")
            self.loadingAnimationStop()
        case .networkFail: print("networkFail") }
        }
        
    }
    
    @IBAction func signUpButtonSelected(_ sender: Any) {
        guard let receiveViewController = self.storyboard?.instantiateViewController(withIdentifier: LoginNagivationVC.identifier) as? LoginNagivationVC else {return}
        receiveViewController.modalPresentationStyle = .fullScreen
        self.present(receiveViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func previewButtonSelected(_ sender: Any) {
        loadingAnimation()
        let inputID = "dummy"
        let inputPWD = "dummy"
        
        LoginService.shared.login(email: inputID, password: inputPWD) { networkResult in switch networkResult {
        case .success(let token):
            // 자동로그인이 선택되어 있으면 id,pwd를 공유객체에 저장함
            let dataSave = UserDefaults.standard // UserDefaults.standard 정의
            dataSave.setValue(inputID, forKey: "save_userNm") // save_userNm 키값에 id값 저장
            dataSave.setValue(inputPWD, forKey: "save_pw") // save_pw 키값에 pw값 저장
            UserDefaults.standard.synchronize() // setValue 실행
            
            guard let token = token as? String else { return }
            UserDefaults.standard.set(token, forKey: "token")
            print("myToken:",token)
            print("\(UserDefaults.standard.value(forKey: "save_userNm")!)")
            print("\(UserDefaults.standard.value(forKey: "save_pw")!)")
            // 로그인 성공시 뷰 전환
            let tabbarStoryboard = UIStoryboard.init(name: "MainTab", bundle: nil)
            guard let mainView = tabbarStoryboard.instantiateViewController(identifier:"TabbarVC") as?
                    TabbarVC else { return }
            mainView.modalPresentationStyle = .fullScreen
            self.present(mainView, animated: true, completion: nil)
            self.loadingAnimationStop()
        case .requestErr(let message):
            let alertViewController = UIAlertController(title: "로그인 실패", message: "아이디와 비밀번호를 확인해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
            print("requestErr")
            self.loadingAnimationStop()
        case .pathErr:
            let alertViewController = UIAlertController(title: "로그인 실패", message: "아이디와 비밀번호를 확인해주세요", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertViewController.addAction(action)
            self.present(alertViewController, animated: true, completion: nil)
            print("pathErr")
            self.loadingAnimationStop()
        case .serverErr: print("serverErr")
        case .networkFail: print("networkFail") }
        }
        
        
        
    }
    
    
    
    
    
    
    
}
