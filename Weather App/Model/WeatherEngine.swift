//
//  WeatherEngine.swift
//  Weather App
//
//  Created by Prosper Evergreen on 16.07.2020.
//  Copyright © 2020 proSPEC. All rights reserved.
//

import Foundation
import CoreLocation

// protocol for weather engine
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherEngine: WeatherEngine, weather: WeatherModel)
    func didFailWithError(_ weatherEngine: WeatherEngine, error: Error)
}

struct WeatherEngine {
    
    var delegate: WeatherManagerDelegate?
    let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather?appid=<Your API Key>&units=metric"
    
    //func to fetch weather using city name
    func fetchWeather(cityName: String){
        let completeURL = "\(weatherBaseURL)&q=\(cityName)"
        httpRequest(with: completeURL)
    }
    
    //func to fetch data using latitude and longitude
    func fetchWeather(latitude: CLLocationDegrees,longitude: CLLocationDegrees) {
        let completeURL = "\(weatherBaseURL)&lat=\(latitude)&lon=\(longitude)"
        httpRequest(with: completeURL)
    }
    
    //http request to the internet
    func httpRequest(with urlString: String) {
        
        //1. Create a URL object
        if let url = URL(string: urlString){
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a data task
            let task = session.dataTask(with: url){(data,_, error) in
                //on response fail
                if error != nil {
                    self.delegate?.didFailWithError(self, error: error!)
                    return
                }
                // on response successful
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
    
    // decoding the recieved JSOn data to Swift object
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
    
}
