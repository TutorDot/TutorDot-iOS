//
//  PasswordData.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/11/30.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation

struct PasswordData: Codable {
    var status: Int
    var success: Bool
    var message: String
    var data: UserPassword?
    
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
        data = (try? values.decode(UserPassword.self, forKey: .data)) ?? nil
    }
}

struct UserPassword: Codable {
    var email: String
    var newPassword: String
}

