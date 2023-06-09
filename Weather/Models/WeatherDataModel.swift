//
//  WeatherDataModel.swift
//  Weather
//
//  Created by Shawn on 6/8/23.
//

import Foundation

struct WeatherDataModel: Decodable {
    var coord: Coordinates
    var weather: [WeatherInfo]
    var main: TemperatureInfo
    var visibility: Int?
    var dt: Double? // Unix Timestamp UTC
    var sys: SunInfo // Sunrise and Sunsine Time
    var name: String? // City Name
    
    struct Coordinates: Decodable {
        var lon: Double? // Longitude
        var lat: Double? // Latitude
    }

    struct WeatherInfo: Decodable {
        var main: String? // Weather
        var description: String? // Weather description
        var icon: String? // Weather icon
    }

    struct TemperatureInfo: Decodable {
        var temp: Double? // Current temperature
        var feelsLike: Double? // Feels like temperature
        var tempMin: Double? // Minimum temperature
        var tempMax: Double? // Maximum temperature
        var humidity: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
        }
    }

    struct SunInfo: Decodable {
        var sunrise: Double? // Sunrise Unix Timestamp UTC
        var sunset: Double? // Sunset Unix Timestamp UTC
    }
}
