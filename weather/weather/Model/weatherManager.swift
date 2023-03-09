//
//  weatherManager.swift
//  weather
//
//  Created by Admin on 11/07/22.
//

import Foundation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_weatherManager: WeatherManager, weather:weatherModel)
    func didFailWithError(error:Error)
}
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=b944a6becb97420a65ecb8402fe20ea8&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in      //closure
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    
                    return
                    
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData)
                    {
                        
                        self.delegate?.didUpdateWeather(_weatherManager: self, weather: weather)
                        
                    }
                }
            }
            task.resume()
        }
        
    }
//    func handle(data: Data?, response: URLResponse?, error:Error?) {    //instead this = closure
//        if error != nil {
//            print(error!)
//            return
//
//        }
//        if let safeData = data {
//            let dataString = String(data: safeData, encoding: .utf8)
//            print(dataString)
//        }
//    }
//
    func parseJSON(weatherData: Data)  -> weatherModel?{
        let decoder = JSONDecoder()
        do {
             let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = weatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
    
        } catch {
            delegate?.didFailWithError(error: error)
            
            return nil
        }
        
    }
    
}
