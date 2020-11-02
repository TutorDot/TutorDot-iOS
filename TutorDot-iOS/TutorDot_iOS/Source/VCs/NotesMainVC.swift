//
//  NotesMainVC.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/10/14.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import os

class NotesMainVC: UIViewController {

    var noteTitle: String?
    let progressViewHeight: CGFloat = 115
    let infoViewHeight: CGFloat = 170
    let dateFomatter = DateFormatter()
    var month: String?
    
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
        noteTitle = titleLabel.text
        setasDefault()
        noteCollectionView.delegate = self
        noteCollectionView.dataSource = self
        noteCollectionView.register(UINib.init(nibName: "NotesContentCell", bundle: nil), forCellWithReuseIdentifier: "noteContent")
//        if let flowLayout = noteCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setProgressView()
    }
    
    func setasDefault(){
        classProgressBar.layer.cornerRadius = 8
        dateFomatter.dateFormat = "MM"
        month = dateFomatter.string(from: Date())
        monthLabel.text = month! + "월 수업일지"
        
    }
    
    func setProgressView(){
        if noteTitle == "전체" {
            progressView.isHidden = true
            progressHeight.constant = 0
            infoStackViewHeight.constant = infoViewHeight - progressViewHeight
        } else {
            progressView.isHidden = false
            progressHeight.constant = progressViewHeight
            infoStackViewHeight.constant = infoViewHeight
        }
    }
    
}

extension NotesMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteContent", for: indexPath)
        return cell
        
    }
    
    
    

    
}
