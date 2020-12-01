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
   
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteCollectionView.delegate = self
        noteCollectionView.dataSource = self
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
        notelist = ["hihi","hoho"]
        print("notelist - ", notelist.count)
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
            collectionViewTop.constant = 0
            
        } else {
            progressView.isHidden = false
            progressHeight.constant = progressViewHeight
            infoStackViewHeight.constant = infoViewHeight
        }
    }
    
    // collection view layout
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
       
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.62)
//        flowLayout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 17)
//        flowLayout.sectionFootersPinToVisibleBounds = true
        
        
        self.noteCollectionView.collectionViewLayout = flowLayout
    }
    
    private func setupBlankFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: noteCollectionView.frame.height)
        
        self.noteCollectionView.collectionViewLayout = flowLayout
    }
    
    @IBAction func test(_ sender: Any) {
        print("tap!!!!")
    }
    
    @IBAction func selectClassButtonDidtap(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "BottomSheetVC") as? BottomSheetVC else {return}
        self.navigationController?.pushViewController(nextVC, animated: true)
        print("tap???")
        nextVC.delegate = self
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
        
        
        let noteBlankCell = BlankNoteCell.cellForCollectionView(collectionView: noteCollectionView, indexPath: indexPath)
        let noteContentCell = NotesContentCell.cellForCollectionView(collectionView: noteCollectionView, indexPath: indexPath)
//        let noteHeaderCell = noteHeaderViewCell.cellForCollectionView(collectionView: noteCollectionView, indexPath: indexPath)
        
        
        if notelist.count > 0 {
            os_log("cell load", log: .note)
            return noteContentCell
        } else {
            return noteBlankCell
        }
    
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let width: CGFloat = noteCollectionView.frame.width
//        let height: CGFloat = 17
//        return CGSize(width: width, height: height)
//
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
   
    
}
