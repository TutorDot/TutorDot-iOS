//
//  Extensions+OSLog.swift
//  TutorDot_iOS
//
//  Created by 최인정 on 2020/10/01.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation
import os

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let ui = OSLog(subsystem: subsystem, category: "UI")
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let calender = OSLog(subsystem: subsystem, category: "Calender")
    static let note = OSLog(subsystem: subsystem, category: "Note")
    static let notice = OSLog(subsystem: subsystem, category: "Notice")
    static let Login = OSLog(subsystem: subsystem, category: "Login")
    static let mypage = OSLog(subsystem: subsystem, category: "Mypage")
}
