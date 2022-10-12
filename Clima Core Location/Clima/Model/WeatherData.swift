//
//  WeatherData.swift
//  Clima
//
//  Created by Muhammad Shaeel Abbas on 29/03/2022.
//  Copyright © 2022 App Brewery. All rights reserved. 
//

import Foundation
struct WeatherData : Decodable { //Used later for Weather object
    let name: String
    let main: Main
    let weather : [Weather]
}

struct Main : Decodable {
    let temp : Double
    let feels_like : Double
    let temp_min : Double
}

struct Weather : Decodable {
    let id : Int
    
}
