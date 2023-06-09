//
//  HomeViewController.swift
//  Weather
//
//  Created by Shawn on 6/8/23.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cityNameSearchBar: UISearchBar!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var lastUpdatedTimeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let viewModel = WeatherViewModel()
    var coordinates:[GeocodingDataModel] = []
    var latitudeString: String = ""
    var longitudeString: String = ""
    var weatherDataSource: WeatherDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameSearchBar.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if let lastSearchedCity = viewModel.getLastSearchedCity() {
            self.fetchCityCoordinates(cityName: lastSearchedCity)
        } else if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func fetchCityCoordinates(cityName: String) {
        let geocodingAPIUrl = URL(string: AppConstants.URL.geocodingAPIRootUrl + AppConstants.URL.cityParam + cityName + AppConstants.URL.apiKeyParam + AppConstants.URL.apiKey)
        viewModel.fetchGeocodingData(url: geocodingAPIUrl) { location in
            self.coordinates = location
            if let latitudeDouble = self.coordinates.first?.lat, let longitudeDouble = self.coordinates.first?.lon {
                self.latitudeString = String(latitudeDouble)
                self.longitudeString = String(longitudeDouble)
                self.viewModel.setLastSearchedCity(city: cityName)
                self.searchCurrentWeather(latitude: self.latitudeString, longitude: self.longitudeString)
            }
        }
    }
    
    func searchCurrentWeather(latitude: String, longitude: String) {
        let weatherAPIUrl = URL(string: AppConstants.URL.weatherAPIRootUrl + AppConstants.URL.latitudeParam + latitude + AppConstants.URL.longitudeParam + longitude + AppConstants.URL.unitsParam + AppConstants.URL.imperialUnit + AppConstants.URL.apiKeyParam + AppConstants.URL.apiKey)
        viewModel.fetchWeatherData(url: weatherAPIUrl) { weatherData in
            self.weatherDataSource = weatherData
            self.locationManager.stopUpdatingLocation()
            self.displayWeatherInfo()
        }
    }
    
    func displayWeatherInfo() {
        if let weatherIcon = self.weatherDataSource?.weather[0].icon, let cityName = self.weatherDataSource?.name, let temperature = self.weatherDataSource?.main.temp, let weather = self.weatherDataSource?.weather[0].main, let weatherDesc = self.weatherDataSource?.weather[0].description, let minTemp = self.weatherDataSource?.main.tempMin, let maxTemp = self.weatherDataSource?.main.tempMax, let feelsLike = self.weatherDataSource?.main.feelsLike, let humidity = self.weatherDataSource?.main.humidity, let sunriseTime = self.weatherDataSource?.sys.sunrise, let sunsetTime = self.weatherDataSource?.sys.sunset, let lastUpdatedTime = self.weatherDataSource?.dt {
            DispatchQueue.global(qos: .background).async {
                let iconUrl = URL(string: AppConstants.URL.iconRootUrl + weatherIcon + AppConstants.URL.iconExtension)
                do {
                    guard let url = iconUrl else { return }
                    let iconData = try Data(contentsOf: url)
                    let iconImage = UIImage(data: iconData)
                    DispatchQueue.main.async {
                        self.weatherIconImage.image = iconImage
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            DispatchQueue.main.async {
                self.cityNameLabel.text = cityName
                self.temperatureLabel.text = String(Int(temperature)) + "°"
                self.weatherLabel.text = weather
                self.weatherDescriptionLabel.text = weatherDesc
                self.minTemperatureLabel.text = "L:" + String(Int(minTemp)) + "°"
                self.maxTemperatureLabel.text = "H:" + String(Int(maxTemp)) + "°"
                self.feelsLikeTemperatureLabel.text = String(Int(feelsLike)) + "°"
                self.humidityLabel.text = String(humidity) + "%"
                self.sunriseTimeLabel.text = TimeUtil.unixTimeToDate(unixTime: sunriseTime, isFullDateFormat: false)
                self.sunsetTimeLabel.text = TimeUtil.unixTimeToDate(unixTime: sunsetTime, isFullDateFormat: false)
                self.lastUpdatedTimeLabel.text = "Last updated: " + TimeUtil.unixTimeToDate(unixTime: lastUpdatedTime, isFullDateFormat: true)
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let trimmedCityName = cityNameSearchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedCityName == "" {
            let alertController = UIAlertController(title: AppConstants.Alert.emptyNameTitle, message: AppConstants.Alert.emptyNameMessage, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: AppConstants.Alert.emptyNameActionTitle, style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if let cityName = trimmedCityName?.replacingOccurrences(of: " ", with: "+") {
            self.fetchCityCoordinates(cityName: cityName)
        }
        cityNameSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cityNameSearchBar.resignFirstResponder()
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            self.searchCurrentWeather(latitude: String(latitude), longitude: String(longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
