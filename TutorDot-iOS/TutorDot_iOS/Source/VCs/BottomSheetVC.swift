//
//  BottomSheetVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/11.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

class BottomSheetVC: UIViewController {

    @IBOutlet weak var BottomSheetTableView: UITableView!
    
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    private var classlist: [String] = []
    let customHeight: CGFloat = 55
    let bottomSafeArea: CGFloat = 34
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomView()
        setClassList()
        
        BottomSheetTableView.dataSource = self
        BottomSheetTableView.delegate = self
        
        start()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var heightCalc = (self.customHeight * (CGFloat(classlist.count)+1)) + bottomSafeArea
        
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
        classlist = ["전체", "수업이름1", "수업이름2"]
        //Mark: - 서버통신
    }
    
    func setupBottomView(){
        BottomSheetTableView.layer.cornerRadius = 13.0
    }
   
    func start(){
        BottomSheetTableView.separatorStyle = .none
        var heightCalc = self.customHeight * (CGFloat(classlist.count)+1) + bottomSafeArea
        
        //init position
        BottomSheetTableView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: heightCalc)
        
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
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
   
}
