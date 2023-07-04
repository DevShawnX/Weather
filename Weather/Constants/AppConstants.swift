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
        static let emptyNameTitle = "Error!"
        static let emptyNameMessage = "Please enter a city name!"
        static let emptyNameActionTitle = "OK"
        static let apiKeyFetchError = "Unable to read API Key from Config file!"
        static let geocodingApiUrlError = "Failed to get geocoding API URL!"
        static let geocodingApiStatusCode = "Geocoding API HTTP Status Code: "
        static let weatherApiUrlError = "Failed to get weather API URL!"
        static let weatherApiStatusCode = "Weather API HTTP Status Code: "
    }
    
    static let emptyValue = ""
    static let space = " "
    static let degree = "°"
    static let percentage = "%"
    static let plus = "+"
    static let low = "Low:"
    static let high = "High:"
    static let lastUpdated = "Last updated: "
    static let config = "Config"
    static let plist = "plist"
    static let apiKey = "ApiKey"
    static let lastSearchedCity = "LastSearchedCity"
}
