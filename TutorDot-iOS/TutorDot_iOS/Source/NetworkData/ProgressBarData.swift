//
//  ProgressBarData.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/12/02.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation

struct ProgressBarData: Codable {
    var status: Int
    var success: Bool
    var message: String
    var data: [BarInfo]
    
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
        data = (try? values.decode([BarInfo].self, forKey: .data)) ?? []
    }
}

struct BarInfo: Codable {
    var times: Int
    var hour: Int
    var depositCycle: Int
    var classDate: String

    
    init(times: Int, hour: Int, depositCycle: Int, classDate: String) {
        self.times = times
        self.hour = hour
        self.depositCycle = depositCycle
        self.classDate = classDate
    }
}
