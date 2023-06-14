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
    var latitudeString: String = AppConstants.emptyValue
    var longitudeString: String = AppConstants.emptyValue
    var weatherDataSource: WeatherDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameSearchBar.delegate = self
        // Request location pemission from users, the app will automatically load weather data of user's current location if permission granted. The app will automatically load weather data of the last city user manually searched upon launch.
        locationManager.requestWhenInUseAuthorization()
        if let lastSearchedCity = viewModel.getLastSearchedCity() {
            self.fetchCityCoordinates(cityName: lastSearchedCity)
        } else if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.allowsBackgroundLocationUpdates = false
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    // This method is used to call Geocoding API and fetch coordinates
    func fetchCityCoordinates(cityName: String) {
        let geocodingAPIUrl = URL(string: AppConstants.URL.geocodingAPIRootUrl + AppConstants.URL.cityParam + cityName + AppConstants.URL.apiKeyParam + fetchApiKey())
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
    
    // This method is used to call current weather API and fetch weather data
    func searchCurrentWeather(latitude: String, longitude: String) {
        let weatherAPIUrl = URL(string: AppConstants.URL.weatherAPIRootUrl + AppConstants.URL.latitudeParam + latitude + AppConstants.URL.longitudeParam + longitude + AppConstants.URL.unitsParam + AppConstants.URL.imperialUnit + AppConstants.URL.apiKeyParam + fetchApiKey())
        viewModel.fetchWeatherData(url: weatherAPIUrl) { weatherData in
            self.weatherDataSource = weatherData
            self.displayWeatherInfo()
        }
    }
    
    // This method is used to display weather info on the UI
    func displayWeatherInfo() {
        if let weatherIcon = self.weatherDataSource?.weather[0].icon, let cityName = self.weatherDataSource?.name, let temperature = self.weatherDataSource?.main.temp, let weather = self.weatherDataSource?.weather[0].main, let weatherDesc = self.weatherDataSource?.weather[0].description, let minTemp = self.weatherDataSource?.main.tempMin, let maxTemp = self.weatherDataSource?.main.tempMax, let feelsLike = self.weatherDataSource?.main.feelsLike, let humidity = self.weatherDataSource?.main.humidity, let sunriseTime = self.weatherDataSource?.sys.sunrise, let sunsetTime = self.weatherDataSource?.sys.sunset, let lastUpdatedTime = self.weatherDataSource?.dt {
            // Cache image
            DispatchQueue.global(qos: .background).async {
                if let image = CacheImage.shared.getImageCache(key: weatherIcon) {
                    DispatchQueue.main.async {
                        self.weatherIconImage.image = image
                    }
                } else {
                    let iconUrl = URL(string: AppConstants.URL.iconRootUrl + weatherIcon + AppConstants.URL.iconExtension)
                    do {
                        guard let url = iconUrl else { return }
                        let iconData = try Data(contentsOf: url)
                        let iconImage = UIImage(data: iconData)
                        if let image = iconImage {
                            CacheImage.shared.setImage(image: image, key: weatherIcon)
                            DispatchQueue.main.async {
                                self.weatherIconImage.image = image
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.cityNameLabel.text = cityName
                self.temperatureLabel.text = String(Int(temperature)) + AppConstants.degree
                self.weatherLabel.text = weather
                self.weatherDescriptionLabel.text = weatherDesc
                self.minTemperatureLabel.text = AppConstants.low + String(Int(minTemp)) + AppConstants.degree
                self.maxTemperatureLabel.text = AppConstants.high + String(Int(maxTemp)) + AppConstants.degree
                self.feelsLikeTemperatureLabel.text = String(Int(feelsLike)) + AppConstants.degree
                self.humidityLabel.text = String(humidity) + AppConstants.percentage
                self.sunriseTimeLabel.text = TimeUtil.unixTimeToDate(unixTime: sunriseTime, isFullDateFormat: false)
                self.sunsetTimeLabel.text = TimeUtil.unixTimeToDate(unixTime: sunsetTime, isFullDateFormat: false)
                self.lastUpdatedTimeLabel.text = AppConstants.lastUpdated + TimeUtil.unixTimeToDate(unixTime: lastUpdatedTime, isFullDateFormat: true)
            }
        }
    }
}

// MARK: - UISearchBar Delegate Functions
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let trimmedCityName = cityNameSearchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedCityName == AppConstants.emptyValue {
            let alertController = UIAlertController(title: AppConstants.Alert.emptyNameTitle, message: AppConstants.Alert.emptyNameMessage, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: AppConstants.Alert.emptyNameActionTitle, style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            let warningGenerator = UINotificationFeedbackGenerator()
            warningGenerator.notificationOccurred(.warning)
        }
        
        if let cityName = trimmedCityName?.replacingOccurrences(of: AppConstants.space, with: AppConstants.plus) {
            self.fetchCityCoordinates(cityName: cityName)
            let successGenerator = UINotificationFeedbackGenerator()
            successGenerator.notificationOccurred(.success)
        }
        cityNameSearchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        cityNameSearchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}

// MARK: - CLLocationManager Delegate Functions
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            manager.stopUpdatingLocation()
            self.searchCurrentWeather(latitude: String(latitude), longitude: String(longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - Fetch API KEY FROM CONFIG PLIST
extension HomeViewController {
    func fetchApiKey() -> String {
        guard let configPath = Bundle.main.path(forResource: AppConstants.config, ofType: AppConstants.plist), let config = NSDictionary(contentsOfFile: configPath), let apiKey = config[AppConstants.apiKey] as? String else {
            fatalError(AppConstants.Alert.apiKeyFetchError)
        }
        return apiKey
    }
}
