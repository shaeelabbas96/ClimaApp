//
//  WeatherManager.swift
//  Clima
//
//  Created by Muhammad Shaeel Abbas on 26/03/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error:Error)
}
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=a0307220ccdc64307fd12bbc9390ff22&units=metric"

    
    
    weak var delegate: WeatherManagerDelegate?
    func fetchWeather(cityName: String)
    {
        let urlString = "\(weatherURL)&q=\(cityName)" //Simply concatinate with string
        performRequest(with: urlString)
    }
    
    func fetchWeather(lat: CLLocationDegrees, long: CLLocationDegrees)
    {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(long)"
        print(urlString)
        performRequest(with: urlString)

    }
    
    func performRequest(with urlString: String)
    {
        // 1) Create URL, 2) Create URLSession, 3) Give URLSession a Task 4) Start the task
        
    
        //1. Create a URL
        
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession
             
            let session = URLSession(configuration: .default) //goes here in case of wrong
            
            //3. Give a URLSession Task
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print(response ?? "no response")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self,weather: weather)
                }
            } //All this is closure body
            }
            //4. Start the task
            
            task.resume()
        }
    }
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodeData.name
            let temp = decodeData.main.temp
            let id = decodeData.weather[0].id
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp) //Data being used for Model
            return weather
        } catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
