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
    var dt: Double? //Unix Timestamp UTC
    var sys: SunInfo //Sunrise and Sunsine Time
    var name: String? //City Name
    
    struct Coordinates: Decodable {
        var lon: Double?
        var lat: Double?
    }

    struct WeatherInfo: Decodable {
        var main: String?
        var description: String?
        var icon: String?
    }

    struct TemperatureInfo: Decodable {
        var temp: Double?
        var feelsLike: Double?
        var tempMin: Double?
        var tempMax: Double?
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
        var sunrise: Double?
        var sunset: Double?
    }
}
