//
//  PopUpClassListTableViewCell.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/11.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit

class PopUpClassListTableViewCell: UITableViewCell {

    static let identifier: String = "PopUpClassListTableViewCell"
    @IBOutlet weak var classNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setClassLabel(className: String){
        classNameLabel.text = className
    }
}
