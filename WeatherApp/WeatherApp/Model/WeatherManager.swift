//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by NISHANT RANJAN on 15/3/20.
//  Copyright © 2020 NISHANT RANJAN. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=fbe4f31ac44182c38d68ead30cd67c73&units=metric"
   
    var delegate : WeatherManagerDelegate?
    
    
    func fetchWeather(citiName: String) {
        let urlString = "\(weatherUrl)&q=\(citiName)"
        performUrlRequest(urlString: urlString)
    }
    
    func performUrlRequest(urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, url, error) in
               
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let dataValue = data {
                    let dataString = String(data: dataValue, encoding: .utf8)
                    print(dataString!)
                    if let weather = self.parseJsonData(weatherData: dataValue) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJsonData(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
       let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.name)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weatherModel = WeatherModel(conditionID: id, citiName: name, tempreture: temp)
            return weatherModel
        }
        catch {
           print(error)
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func fetchWeatherData(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
        performUrlRequest(urlString: urlString)
    }
    
}
