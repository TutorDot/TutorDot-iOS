//
//  TutorProfileEditVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/10.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

class TutorProfileEditVC: UIViewController {

    let introDefault: String = ""
    
    // 이전 뷰에서 받을 내용
    @IBOutlet weak var introMention: UITextField?
    @IBOutlet weak var roleLabel: UILabel!
    var profileURL: String = ""
    var introStr: String = ""
    
    @IBOutlet weak var profileImage: UIButton!
    private var imagePickerController = UIImagePickerController()
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerHeightContraints: NSLayoutConstraint!
    @IBOutlet weak var introText: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        viewWillAppear(true)

        autoLayoutView()
        setUpView()
        setProfile()
        
        profileImage.isHidden = true // 프로필 수정버튼 숨기기
        
        introMention?.addTarget(self, action: #selector(TutorProfileEditVC.textFieldDidChange(_:)), for: .editingChanged)
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.introStr = introMention?.text ?? ""
    }
    
    func setUpView(){
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    func autoLayoutView(){
         headerHeightContraints.constant = self.view.frame.height * 94/812
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    

    // 화면 터치 시, 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        ProfileService.ProfileServiceShared.editProfile(intro: introStr){ networkResult in
            switch networkResult {
            case .success:
                // 수업연결 해제 성공 alert
                let alert = UIAlertController(title: "완료", message: "프로필 수정이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {_ in self.dismiss(animated: true, completion: nil)}))
                self.present(alert, animated: true, completion: nil)
            case .pathErr:
                os_log("PathErr", log: .mypage)
            case .serverErr:
                os_log("ServerErr", log: .mypage)
            case .requestErr(let message):
                guard let message = message as? String else { return }
                let alertViewController = UIAlertController(title: "프로필 수정 실패", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alertViewController.addAction(action)
                self.present(alertViewController, animated: true, completion: nil)
            case .networkFail:
                os_log("networkFail", log: .mypage)
            }
            
        }
        
    }
    
    @IBAction func setProfile(_ sender: Any) {
        onClickButton()
    }
    
    func onClickButton(){
        let alertController = UIAlertController(title: "프로필 설정", message: "프로필 사진을 선택하세요!", preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "사진앨범", style: .default) { action in self.openLibrary()
        }
        let photoAction = UIAlertAction(title: "카메라", style: .default) { action in self.openCamera()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(galleryAction)
        alertController.addAction(photoAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Mark - 서버통신 : 간편 프로필 조회
    func setProfile(){
        ProfileService.ProfileServiceShared.setMyProfile() { networkResult in
            switch networkResult {
                case .success(let resultData):
                    os_log("profile success", log: .mypage)
                    guard let data = resultData as? UserProfile else { return print(Error.self) }
                        self.nameLabel.text =  data.userName
                    
                    if data.role == "tutor" {
                        self.roleLabel.text = "튜터"
                    } else {
                        self.roleLabel.text = "튜티"
                    }
                        
                    
                    if data.intro == "" {
                        self.introMention?.text = self.introDefault
                        self.introMention?.textColor = UIColor.gray
                    } else {
                        self.introMention?.text = data.intro
                        self.introMention?.textColor = UIColor.black
                    }
                    self.profileURL = data.profileUrl
                    
                    
                    let url = URL(string: self.profileURL)
                    self.profileImageView.kf.setImage(with: url)

                case .pathErr :
                    os_log("PathErr-Profile", log: .mypage)
                case .serverErr :
                    os_log("ServerErr", log: .mypage)
                case .requestErr(let message) :
                    print(message)
                case .networkFail:
                    os_log("networkFail", log: .mypage)
            }
        }
    }
    
}

extension TutorProfileEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func openLibrary(){
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.modalTransitionStyle = .crossDissolve
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func openCamera(){
        imagePickerController.sourceType = .camera
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.modalTransitionStyle = .crossDissolve
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
            [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let url =
                info[UIImagePickerController.InfoKey.imageURL] as? URL {

//                guard let token = UserDefaults.standard.object(forKey: "token") as? String else { return }
                ProfileService.ProfileServiceShared.uploadImage(image, url.lastPathComponent) { networkResult in
                    switch networkResult {
                    case .success(let profileData):
                        guard let profileData = profileData as? UserProfile else { return }
                        print(profileData.profileUrl)
                    case .requestErr(let failMessage):
                        guard let message = failMessage as? String else { return }
                        print(message)
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                    }
                }
                profileImageView.image = image
            }
            dismiss(animated: true, completion: nil)
        }
    
}
