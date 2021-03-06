//
//  NotesData.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/12/01.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation

struct NotesData: Codable {
    var status: Int
    var success: Bool
    var message: String
    var data: [NotesContentServer]
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case success = "success"
        case message = "message"
        case data = "data"
    }
     
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? -1
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode([NotesContentServer].self, forKey: .data)) ?? []
    }
}

struct NotesContentServer: Codable {
    var diaryId: Int
    var profileUrl: String
    var lectureName: String
    var classDate: String
    var color: String
    var times: Int
    var hour: Int
    var depositCycle: Int
    var classProgress: String
    var homework: String
    var hwPerformance:Int

    
    init (diaryId: Int, profileUrl: String, lectureName: String, classDate: String, color: String, times: Int, hour: Int, depositCycle: Int, classProgress: String, homework:String, hwPerformance: Int) {
        self.diaryId = diaryId
        self.profileUrl = profileUrl
        self.lectureName = lectureName
        self.classDate = classDate
        self.color = color
        self.times = times
        self.hour = hour
        self.depositCycle = depositCycle
        self.classProgress = classProgress
        self.homework = homework
        self.hwPerformance = hwPerformance

    }
}

struct NotesContent: Codable {
    var diaryId: Int
    var profileUrl: String
    var lectureName: String
    var classDate: String
    var color: String
    var times: Int
    var hour: Int
    var depositCycle: Int
    var classProgress: String
    var homework: String
    var hwPerformance:Int
    var dayWeek: String
    
    init (diaryId: Int, profileUrl: String, lectureName: String, classDate: String, color: String, times: Int, hour: Int, depositCycle: Int, classProgress: String, homework:String, hwPerformance: Int, dayWeek: String) {
        self.diaryId = diaryId
        self.profileUrl = profileUrl
        self.lectureName = lectureName
        self.classDate = classDate
        self.color = color
        self.times = times
        self.hour = hour
        self.depositCycle = depositCycle
        self.classProgress = classProgress
        self.homework = homework
        self.hwPerformance = hwPerformance
        self.dayWeek = dayWeek
    }
}
