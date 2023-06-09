//
//  AppConstants.swift
//  Weather
//
//  Created by Shawn on 6/8/23.
//

import Foundation

enum AppConstants {
    enum URL {
        static let geocodingAPIRootUrl = "https://api.openweathermap.org/geo/1.0/direct?"
        static let cityParam = "q="
        static let apiKeyParam = "&appid="
        //TODO: Store API Key in Plist
        static let apiKey = "2d100bbd702642e47facdc29707c728b"
        static let weatherAPIRootUrl = "https://api.openweathermap.org/data/2.5/weather?"
        static let latitudeParam = "lat="
        static let longitudeParam = "&lon="
        static let unitsParam = "&units="
        static let metricUnit = "metric"
        static let imperialUnit = "imperial"
        static let iconRootUrl = "https://openweathermap.org/img/wn/"
        static let iconExtension = "@2x.png"
    }
    
    enum Alert {
        static let emptyNameTitle = "Heads Up!"
        static let emptyNameMessage = "Please enter a city name!"
        static let emptyNameActionTitle = "OK"
    }
}
