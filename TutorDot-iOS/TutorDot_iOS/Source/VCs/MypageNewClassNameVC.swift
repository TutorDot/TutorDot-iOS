//
//  MypageNewClassNameVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/26.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os


class MypageNewClassNameVC: UIViewController {

    static let identifier: String = "MypageNewClassNameVC"
    let checkImages: [String] = ["Redcheck", "Yellowcheck", "Greencheck", "Bluecheck", "Purplecheck"]
    let defaultImages: [String] = ["red", "yellow", "green", "blue", "purple"]
    
    var newColor: String = ""
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
    }
   
 
    
    @IBOutlet weak var redColor: UIButton!
    @IBOutlet weak var yellowColor: UIButton!
    @IBOutlet weak var greenColor: UIButton!
    @IBOutlet weak var blueColor: UIButton!
    @IBOutlet weak var purpleColor: UIButton!
    @IBOutlet weak var lectureName: UITextField!
    
    
    
    @IBAction func redColorDidTap(_ sender: Any) {
        redColor.setImage(UIImage(named: checkImages[0]), for: .normal)
        yellowColor.setImage(UIImage(named: defaultImages[1]), for: .normal)
        greenColor.setImage(UIImage(named: defaultImages[2]), for: .normal)
        blueColor.setImage(UIImage(named: defaultImages[3]), for: .normal)
        purpleColor.setImage(UIImage(named: defaultImages[4]), for: .normal)
        
        newColor = "red"
    }
    
    @IBAction func yellowColorDidTap(_ sender: Any) {
        redColor.setImage(UIImage(named: defaultImages[0]), for: .normal)
        yellowColor.setImage(UIImage(named: checkImages[1]), for: .normal)
        greenColor.setImage(UIImage(named: defaultImages[2]), for: .normal)
        blueColor.setImage(UIImage(named: defaultImages[3]), for: .normal)
        purpleColor.setImage(UIImage(named: defaultImages[4]), for: .normal)
        
        newColor = "yellow"
    }
    
    @IBAction func greenColorDidTap(_ sender: Any) {
        redColor.setImage(UIImage(named: defaultImages[0]), for: .normal)
        yellowColor.setImage(UIImage(named: defaultImages[1]), for: .normal)
        greenColor.setImage(UIImage(named: checkImages[2]), for: .normal)
        blueColor.setImage(UIImage(named: defaultImages[3]), for: .normal)
        purpleColor.setImage(UIImage(named: defaultImages[4]), for: .normal)
        
        newColor = "green"
    }
    
    @IBAction func blueColorDidTap(_ sender: Any) {
        redColor.setImage(UIImage(named: defaultImages[0]), for: .normal)
        yellowColor.setImage(UIImage(named: defaultImages[1]), for: .normal)
        greenColor.setImage(UIImage(named: defaultImages[2]), for: .normal)
        blueColor.setImage(UIImage(named: checkImages[3]), for: .normal)
        purpleColor.setImage(UIImage(named: defaultImages[4]), for: .normal)
        
        newColor = "blue"
    }
    
    @IBAction func purpleColorDidTap(_ sender: Any) {
        redColor.setImage(UIImage(named: defaultImages[0]), for: .normal)
        yellowColor.setImage(UIImage(named: defaultImages[1]), for: .normal)
        greenColor.setImage(UIImage(named: defaultImages[2]), for: .normal)
        blueColor.setImage(UIImage(named: defaultImages[3]), for: .normal)
        purpleColor.setImage(UIImage(named: checkImages[4]), for: .normal)
        
        newColor = "purple"
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        lectureName.text = ""
        
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        
        
        
        if lectureName.text == "" || newColor == "" {
            var inputMessage: String = ""
            if lectureName.text == "" {
                inputMessage = "수업명을 입력해주세요."
            } else if newColor == "" {
                inputMessage = "색상을 선택해주세요."
            }
            
            let alert = UIAlertController(title: "필요한 값이 없습니다", message: inputMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            guard let receiveVC = self.storyboard?.instantiateViewController(withIdentifier: "MypageNewClassDetailVC") as? MypageNewClassDetailVC else {return}
            
            receiveVC.classColor = newColor
            receiveVC.className = lectureName.text ?? ""
            
            self.navigationController?.pushViewController(receiveVC, animated: true)
        }
        
        
        
    }
    
    // 화면 터치 시, 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

