//
//  ProfileData.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/07/14.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation

struct ProfileData: Codable {
    var status: Int
    var success: Bool
    var message: String
    var data: UserProfile?
    
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
        data = (try? values.decode(UserProfile?.self, forKey: .data)) ??  nil
    }
}

// 계정 - 간편 프로필 조회
struct UserProfile: Codable {
    var userName: String
    var role: String
    var intro: String?
    var profileUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case userName = "userName"
        case role = "role"
        case intro = "intro"
        case profileUrl = "profileUrl"
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let userName: String = try container.decode(String.self, forKey: .userName)
//        let role: String = try container.decode(String.self, forKey: .role)
//        let intro: String = try container.decode(String.self, forKey: .intro)
//        let profileURL: String = try container.decode(String.self, forKey: .profileURL)
//
//
//        self.init(from: <#Decoder#>, userName: userName, role: role, intro: intro, profileURL: profileURL)
//    }
    
    init(userName: String, role: String, intro: String?, profileUrl: String) {
        self.userName = userName
        self.role = role
        self.intro = intro
        self.profileUrl = profileUrl
    }
}
