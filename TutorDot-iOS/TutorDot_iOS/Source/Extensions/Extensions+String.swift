//
//  Extensions+String.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 05/07/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import Foundation

// String Extension
extension String {

    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var date: Date? {
        return String.dateFormatter.date(from: self)
    }

    var length: Int {
        return self.count
    }
    

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
}
