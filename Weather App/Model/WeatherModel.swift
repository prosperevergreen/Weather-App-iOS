//
//  WeatherModel.swift
//  Weather App
//
//  Created by Prosper Evergreen on 16.07.2020.
//  Copyright © 2020 proSPEC. All rights reserved.
//

import Foundation

struct WeatherModel {
    var cityName: String
    var temperature: Double
    var weatherId: Int
    
    var tempInString:String{
        return String(format: "%.1f", temperature)
    }
    
    var weatherImage: String {
         switch weatherId {
         case 200..<250:
             return "cloud.bolt"
         case 300..<350:
             return "cloud.drizzle"
         case 500..<550:
             return "cloud.rain"
         case 600..<630:
             return "cloud.snow"
         case 700..<750:
             return "cloud.fog"
         case 800:
             return "sun.max"
         case 801..<805:
             return "cloud"
         default:
             return ""
         }
    }
}
