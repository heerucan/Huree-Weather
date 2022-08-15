//
//  Date+.swift
//  Weather
//
//  Created by heerucan on 2022/08/16.
//

import Foundation

extension Date {
    func getCurrentTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일(EEEEE) hh시 mm분"
        return formatter.string(from: now)
    }
}
