//
//  WeatherEngine.swift
//  Weather App
//
//  Created by Prosper Evergreen on 16.07.2020.
//  Copyright © 2020 proSPEC. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherEngine: WeatherEngine, weather: WeatherModel)
    func didFailWithError(_ weatherEngine: WeatherEngine, error: Error)
}

struct WeatherEngine {
    
    var delegate: WeatherManagerDelegate?
    let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather?appid=<API KEY>&units=metric"
    
    func fetchWeather(cityName: String){
        let completeURL = "\(weatherBaseURL)&q=\(cityName)"
        httpRequest(with: completeURL)
    }
    
    func fetchWeather(latitude: CLLocationDegrees,longitude: CLLocationDegrees) {
        let completeURL = "\(weatherBaseURL)&lat=\(latitude)&lon=\(longitude)"
        httpRequest(with: completeURL)
    }
    
    func httpRequest(with urlString: String) {
        
        //1. Create a URL object
        if let url = URL(string: urlString){
           
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url){(data, reponse, error) in
                if error != nil {
                    self.delegate?.didFailWithError(self, error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather =  self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let weather = WeatherModel(cityName: name, temperature: temp, weatherId: id)
            return weather
        }catch{
            self.delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
    
    
//    func httpResponse(data: Data?, response: URLResponse?, error: Error?) {
//        if error != nil {
//            print(error!)
//            return
//        }
//
//        if let safeData = data{
//            let dataJSON = JSONDecoder(safeDate)
//        }
//    }
}
