//
//  MyClassDetailData.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/30.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation

struct MyClassDetailData: Codable {
    var status: Int
    var success: Bool
    var message: String
    var data: ClassDetail?
    
    enum CodingKeys: String, CodingKey{
        case status = "status"
        case success = "success"
        case message = "message"
        case data = "data"
    }
    
    init (from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? -1
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(ClassDetail.self, forKey: .data)) ?? nil
    }
}

struct ClassDetail: Codable {
    var lectureName:String
    var color: String
    var orgLocation: String
    var bank: String
    var accountNo: String
    var depositCycle: Int
    var price: Int
    var userName:String
    var role: String
    var intro: String
    var profileUrl: String
    var schedules: [MySchedulesData]
    
    
    init(lectureName: String, color: String, orgLocation: String, bank: String, accountNo: String, depositCycle: Int, price: Int, userName: String, role: String, intro: String, profileUrl: String, schedules: [MySchedulesData]) {
        self.lectureName = lectureName
        self.color = color
        self.orgLocation = orgLocation
        self.bank = bank
        self.accountNo = accountNo
        self.depositCycle = depositCycle
        self.price = price
        self.userName = userName
        self.role = role
        self.intro = intro
        self.profileUrl = profileUrl
        self.schedules = schedules
    }

    
}

struct MySchedulesData: Codable {
    var day: String
    var orgStartTime: String
    var orgEndTime: String

    init(_ day: String, _ orgStartTime: String, _ orgEndTime: String){
        self.day = day
        self.orgStartTime = orgStartTime
        self.orgEndTime = orgEndTime
    }
}
