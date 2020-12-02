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
    func sendClassTitle(_ title: String, _ lctureId: Int)
}

class BottomSheetVC: UIViewController {
    
    @IBOutlet weak var BottomSheetTableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    
    weak var delegate: selectClassProtocol?
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var classlist: [String] = []
    var lectureId: [Int] = []
    let headerHeight: CGFloat = 55
    let customHeight: CGFloat = 55
    let bottomSafeArea: CGFloat = 34
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bgView.alpha = 0.0
        
        setupBottomView()
        start()
        
        BottomSheetTableView.dataSource = self
        BottomSheetTableView.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        //setListDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Mark: device 분기처리 필요 bottomSafeArea 더할지 말지
        let heightCalc = (self.customHeight * (CGFloat(classlist.count))) + bottomSafeArea + headerHeight
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut, animations: { [self] in
                        
                        self.BottomSheetTableView.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: heightCalc)
                        self.bgView.alpha = 0.0
                       }, completion: nil)
        

        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func setupBottomView(){
        BottomSheetTableView.layer.cornerRadius = 13.0
    }
    
    func start(){
        
        BottomSheetTableView.separatorStyle = .none
        let heightCalc = self.customHeight * (CGFloat(classlist.count)) + bottomSafeArea + headerHeight
        
               
        //init position
        BottomSheetTableView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: heightCalc)

        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut, animations: { [self] in
                        
                        self.bgView.alpha = 0.37
                        
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
        
        return customHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.sendClassTitle(classlist[indexPath.row], lectureId[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}

