//
//  TimeUtil.swift
//  Weather
//
//  Created by Shawn on 6/8/23.
//

import Foundation

class TimeUtil {
    // This method is used to convert Unix Time Stamp in UTC to data and time in local timezone
    static func unixTimeToDate(unixTime: Double, isFullDateFormat: Bool) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = isFullDateFormat ? "MMM d, yyyy HH:mm:ss" : "HH:mm"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
}
