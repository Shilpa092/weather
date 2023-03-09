//
//  ViewController.swift
//  weather
//
//  Created by Admin on 08/07/22.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate ,WeatherManagerDelegate{
 

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextfield: UITextField!
    
    var weatherManager = WeatherManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextfield.delegate = self    //user started typing  ...
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextfield.endEditing(true)   // on click searchcutton keyboard shd dismiss
        print(searchTextfield.text!)  //paris - what user enters
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextfield.endEditing(true)  // on click go(on keyboard), keyboard shd dismiss
        print(searchTextfield.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "type something"
            return false
        }
            
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // use serchtextField.text toget the weather for that city
        if let city = searchTextfield.text {
        weatherManager.fetchWeather(cityName: city)
        }
        searchTextfield.text = ""  //cick on go or searchbutton it clears textfield
    }
    
    
    func didUpdateWeather(_weatherManager:WeatherManager, weather: weatherModel) {
        DispatchQueue.main.async {
            print(weather.temperatureString)
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
      }

    }
    func didFailWithError(error: Error) {
        print(error)
    }
}


