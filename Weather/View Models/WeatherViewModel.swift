//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Shawn on 6/8/23.
//

import Foundation

class WeatherViewModel {
    func fetchWeatherData(url: URL?, completionHandler: @escaping (WeatherDataModel) -> ()) {
        guard let url = url else {
            print("Failed to get API URL!")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print("Weather API HTTP Status Code: \(response.statusCode)")
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
}
