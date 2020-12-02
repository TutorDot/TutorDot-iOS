//
//  MyAllClassListData.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/12/02.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation

struct MyAllClassListData: Codable {
    var status: Int
    var success: Bool
    var message: String
    var data: [MyAllClassList]
    
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
        data = (try? values.decode([MyAllClassList].self, forKey: .data)) ?? []
    }
}

struct MyAllClassList: Codable {
    var lectureId: Int
    var lectureName: String
    var color: String
    var profileUrl: String
    var schedules: [SchedulesData]
    
    init (lectureId: Int, lectureName: String, color: String, profileUrl: String, schedules: [SchedulesData]) {
        self.lectureId = lectureId
        self.lectureName = lectureName
        self.color = color
        self.profileUrls = profileUrls
        self.schedules = schedules
    }
}

struct SchedulesData: Codable {
    var day: String
    var orgStartTime: String
    var orgEndTime: String

    init(_ day: String, _ orgStartTime: String, _ orgEndTime: String){
        self.day = day
        self.orgStartTime = orgStartTime
        self.orgEndTime = orgEndTime
    }
}
