//
//  InvitationData.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/11/30.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation

struct InvitationData: Codable {
    var status: Int
    var success: Bool
    var message: String
    var data: ClassInvitationCode?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case success = "success"
        case message = "message"
        case data = "data"
    }
    
    init(form decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? -1
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(ClassInvitationCode?.self, forKey: .data)) ?? nil
    }
}

struct ClassInvitationCode: Codable {
    var code: String
    
    init(code: String){
        self.code = code
    }
}
