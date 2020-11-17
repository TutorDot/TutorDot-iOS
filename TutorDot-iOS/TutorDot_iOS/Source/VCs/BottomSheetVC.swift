//
//  BottomSheetVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/11.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

protocol selectClassProtocol: class {
    func sendClassTitle(_ title: String)
}

class BottomSheetVC: UIViewController {
    
    @IBOutlet weak var BottomSheetTableView: UITableView!
    weak var delegate: selectClassProtocol?
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    var classlist: [String] = []
    var classFinalList: [String] = []
    let customHeight: CGFloat = 55
    let bottomSafeArea: CGFloat = 34
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomView()
        setClassList()
        BottomSheetTableView.dataSource = self
        BottomSheetTableView.delegate = self
        start()
        setListDropDown()
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        //setListDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let heightCalc = (self.customHeight * (CGFloat(classlist.count)+1)) + bottomSafeArea
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: { [self] in
                        
                        self.BottomSheetTableView.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: heightCalc)
                       }, completion: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setClassList(){
        //classlist = ["전체", "수업이름1", "수업이름2"]
        //Mark: - 서버통신
        
        self.classFinalList = self.classlist
        print(classFinalList)
    }
    
    
    func setListDropDown(){
        // 서버통신: 토글에서 수업리스트 가져오기
        classlist = []
        ProfileService.shared.getClassLid() { networkResult in
            switch networkResult {
            case .success(let resultData):
                guard let data = resultData as? [LidToggleData] else { return print(Error.self) }
                for index in 0..<data.count {
                    let item = LidToggleData(lectureId: data[index].lectureId, lectureName: data[index].lectureName, color: data[index].color, profileUrls: data[index].profileUrls)
                    self.classlist.append(item.lectureName)
                    
                    //print(self.classlist)
                }
                
            case .pathErr : print("Patherr")
            case .serverErr : print("ServerErr")
            case .requestErr(let message) : print(message)
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    
    func setupBottomView(){
        BottomSheetTableView.layer.cornerRadius = 13.0
    }
    
    func start(){
        BottomSheetTableView.separatorStyle = .none
        let heightCalc = self.customHeight * (CGFloat(classlist.count)+1) + bottomSafeArea
        
        //init position
        BottomSheetTableView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: heightCalc)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut, animations: { [self] in
                        self.BottomSheetTableView.frame = CGRect(x: 0, y: self.screenHeight - heightCalc, width: self.screenWidth, height: heightCalc)
                       }, completion: nil)
        
    }
    
}

extension BottomSheetVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let Cell = tableView.dequeueReusableCell(withIdentifier: PopUpClassesTableViewCell.identifier, for: indexPath) as? PopUpClassesTableViewCell
        else { return UITableViewCell() }
        
        Cell.popUpLabel.text = classlist[indexPath.row]
        
        return Cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var classTitle: String = classlist[indexPath.row]
        delegate?.sendClassTitle(classTitle)
        self.dismiss(animated: true, completion: nil)
    }
}

