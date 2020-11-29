//
//  NotesMainVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/10/14.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

class NotesMainVC: UIViewController, selectClassProtocol {

    let deviceHeight: CGFloat = UIScreen.main.bounds.height / 812
    var progressViewHeight: CGFloat = 115
    var infoViewHeight: CGFloat = 170
    let dateFomatter = DateFormatter()
    var month: String?
    let cellInset: CGFloat = 16
    var notelist: [String] = []
    //let subjectSheetVc = sheetViewController()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var classProgressBar: UIProgressView!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressHeight: NSLayoutConstraint!
    @IBOutlet weak var infoStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var noteCollectionView: UICollectionView!
   
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteCollectionView.delegate = self
        noteCollectionView.dataSource = self
        
        noteCollectionView.register(UINib.init(nibName: "NotesContentCell", bundle: nil), forCellWithReuseIdentifier: "noteContent")
        noteCollectionView.register(UINib.init(nibName: "BlankNoteCell", bundle: nil), forCellWithReuseIdentifier: "BlankNoteCell")
        
        setLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setProgressView()
        setasDefault()
    }
    

    private func setasDefault(){
        classProgressBar.layer.cornerRadius = 7.0
        
        dateFomatter.dateFormat = "MM"
        month = dateFomatter.string(from: Date())
        monthLabel.text = month! + "월 수업일지"
        
        //Dummy Data
        //notelist = ["hihi","hoho"]
    }
    
    func setLayout(){
        progressViewHeight = 115 * deviceHeight
        infoViewHeight = 170 * deviceHeight
        
        if notelist.count > 0 {
            setupFlowLayout()
            infoStackView.isHidden = false
            infoStackViewHeight.constant = 150 * deviceHeight
            
        } else {
            setupBlankFlowLayout()
            infoStackView.isHidden = true
            infoStackViewHeight.constant = 0
        }
        
        
    }
    // 프로그래스 바 전체일 때만 보이도록 셋팅
    private func setProgressView(){
        if titleLabel.text == "전체" {
            progressView.isHidden = true
            progressHeight.constant = 0
            infoStackViewHeight.constant = infoViewHeight - progressViewHeight
        } else {
            progressView.isHidden = false
            progressHeight.constant = progressViewHeight
            infoStackViewHeight.constant = infoViewHeight
        }
    }
    
    // collection view layout
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        
        let totalWidth = noteCollectionView.frame.width - (cellInset * 2)
        let sideInset = (noteCollectionView.frame.width - totalWidth) / 2
        
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: sideInset, bottom: 10, right: sideInset)
        
        flowLayout.itemSize = CGSize(width: totalWidth, height: totalWidth * 0.62)
        
        self.noteCollectionView.collectionViewLayout = flowLayout
    }
    
    private func setupBlankFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: noteCollectionView.frame.height)
        
        self.noteCollectionView.collectionViewLayout = flowLayout
    }
    
    
    @IBAction func selectClassButtonDidtap(_ sender: Any) {
        
        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "BottomSheetVC") as? BottomSheetVC else { return }
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        present(popupVC, animated: true, completion: nil)
    }
    
    func sendClassTitle(_ title: String) {
        titleLabel.text = title
        setProgressView()
    }
    
    
}

extension NotesMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if notelist.count > 0 {
            return notelist.count
        } else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteContent", for: indexPath)
        let blankCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlankNoteCell", for: indexPath)
        
        if notelist.count > 0 {
            Cell.contentView.layer.cornerRadius = 13.0
            return Cell
        } else {
            return blankCell
        }
    
        
    }
   
    
}
