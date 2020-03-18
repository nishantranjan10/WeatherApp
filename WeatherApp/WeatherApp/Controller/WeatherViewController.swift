//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by NISHANT RANJAN on 14/3/20.
//  Copyright © 2020 NISHANT RANJAN. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
   
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    @IBOutlet weak var cityLabel: UILabel!
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
         self.searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

extension WeatherViewController : UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
            searchTextField.endEditing(true)
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
          return true
        }
        else {
            textField.placeholder = "Please ente something"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let citi = textField.text {
            weatherManager.fetchWeather(citiName: citi)
        }
        
        searchTextField.text = ""
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel .text = weather.tempretureString
            self.cityLabel.text = weather.citiName
            self.weatherImageView.image = UIImage(systemName: weather.conditionName)
        }
        
    }
    
    func didFailWithError(error: Error) {
           print(error)
       }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            
            print(lat)
            print(long)
            weatherManager.fetchWeatherData(lat: lat, lon: long)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
            }
}
