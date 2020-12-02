//
//  APIConstants.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 2020/07/11.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation

struct APIConstants {
    static let baseURL = "http://15.165.186.228:3000"
    
    // URL Info
    
    // 계정관련
    static let signupURL = APIConstants.baseURL + "/user/signup"
    static let signinURL = APIConstants.baseURL + "/user/signin"
    static let profileURL = APIConstants.baseURL + "/user/profile"
    static let idCheckURL = APIConstants.baseURL + "/user/signin/duplication"
    static let changePassword = APIConstants.baseURL + "/user/changepassword"
    
    // 수업관리
    static let lectureURL = APIConstants.baseURL + "/lecture"  //수업 추가
    static let lidURL = APIConstants.baseURL + "/lecture/:lid"
    static let invitationLidURL = APIConstants.baseURL + "/lecture/invitation/:lid" //수업 초대
    static let invitationURL = APIConstants.baseURL + "/lecture/invitation"
    static let toggleURL = APIConstants.baseURL + "/lecture/toggle"
    static let classListURL = APIConstants.baseURL + "/lecture/name"
    
    // 캘린더
    static let calendarURL = APIConstants.baseURL + "/calander"
    static let calendarLidURL = APIConstants.baseURL + "/calander/:lid"
    static let calendarClassURL = APIConstants.baseURL + "/calander/class"
    static let calendarCidURL = APIConstants.baseURL + "/calander/:cid"
    
    // 수업일지
    static let diaryURL = APIConstants.baseURL + "/diary"
    static let diaryLidURL = APIConstants.baseURL + "/diary/:lid"
    static let diaryBarLidURL = APIConstants.baseURL + "/diary/bar"
    static let diaryHwDidURL = APIConstants.baseURL + "/diary/hw"
    
    // 알림
    static let noticeURL = APIConstants.baseURL + "/notice"
    static let noticeLidURL = APIConstants.baseURL + "/notice/:lid"
    static let noticeDateURL = APIConstants.baseURL + "/notice/date"
    static let noticeUpdateURL = APIConstants.baseURL + "/notice/update"
}
