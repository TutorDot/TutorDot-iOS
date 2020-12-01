//
//  NoteModifyData.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/12/01.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation

struct NoteModifyData {
    var status: Int
    var success: Bool
    var message: String
    var data: NoteModify?
    
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
        data = (try? values.decode(NoteModify.self, forKey: .data)) ?? nil
    }
}

struct NoteModify {
    var classProgress: String
    var homework: String
    var hwPerformance: Int
}
