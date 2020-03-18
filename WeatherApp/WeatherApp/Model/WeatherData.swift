//
//  WeatherData.swift
//  WeatherApp
//
//  Created by NISHANT RANJAN on 16/3/20.
//  Copyright © 2020 NISHANT RANJAN. All rights reserved.
//

import Foundation

struct  WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [weather]
}

struct Main : Decodable {
    let temp : Double
}

struct weather: Decodable {
    let description : String
    let id: Int
    

}
