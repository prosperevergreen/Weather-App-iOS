//
//  ViewController.swift
//  Weather App
//
//  Created by Prosper Evergreen on 16.07.2020.
//  Copyright © 2020 proSPEC. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchInput: UITextField!
    var weatherEngine = WeatherEngine()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchInput.delegate = self
        weatherEngine.delegate = self
    }
  
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
           searchInput.endEditing(true)
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.endEditing(true)
           return true
       }
       
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           if textField.text != ""{
               return true
           }else{
               textField.placeholder = "Type a City"
               return false
           }
       }
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           
           if let city = searchInput.text{
               weatherEngine.fetchWeather(cityName: city)
           }
           searchInput.text = ""
       }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherEngine: WeatherEngine, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.tempInString
            self.conditionImageView.image = UIImage (systemName: weather.weatherImage)
        }
    }
    
    func didFailWithError(_ weatherEngine: WeatherEngine, error: Error) {
        print(error)
    }

}

//MARK: -  CLLocationManagerDelegate

extension WeatherViewController:  CLLocationManagerDelegate{
    
    @IBAction func updateLocationWeather(_ sender: UIButton) {
        locationManager.requestLocation()
      }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherEngine.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
