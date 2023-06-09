//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Shawn on 6/8/23.
//

import Foundation

class WeatherViewModel {
    // This method is used to fetch coordinates of given city
    func fetchGeocodingData(url: URL?, completionHandler: @escaping ([GeocodingDataModel]) -> Void) {
        guard let url = url else {
            print(AppConstants.Alert.geocodingApiUrlError)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(AppConstants.Alert.geocodingApiStatusCode + "\(response.statusCode)")
            }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONDecoder().decode([GeocodingDataModel].self, from: data)
                completionHandler(json)
            } catch {
                print(error.localizedDescription)
                return
            }
        }.resume()
    }
    
    // This method is used to fetch weather data of given coordinates
    func fetchWeatherData(url: URL?, completionHandler: @escaping (WeatherDataModel) -> Void) {
        guard let url = url else {
            print(AppConstants.Alert.weatherApiUrlError)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(AppConstants.Alert.weatherApiStatusCode + "\(response.statusCode)")
            }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                completionHandler(json)
            } catch {
                print(error.localizedDescription)
                return
            }
        }.resume()
    }
    
    func setLastSearchedCity(city: String) {
        UserDefaults.standard.set(city, forKey: AppConstants.lastSearchedCity)
    }
    
    func getLastSearchedCity() -> String? {
        UserDefaults.standard.string(forKey: AppConstants.lastSearchedCity)
    }
}
