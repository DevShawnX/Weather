//
//  TimeUtil.swift
//  Weather
//
//  Created by Shawn on 6/8/23.
//

import Foundation

class TimeUtil {
    static func unixTimeToDate(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
}
