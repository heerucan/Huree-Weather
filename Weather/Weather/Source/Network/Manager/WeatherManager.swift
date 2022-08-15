//
//  WeatherManager.swift
//  Weather
//
//  Created by heerucan on 2022/08/16.
//

import UIKit

import Alamofire
import SwiftyJSON

struct WeatherManager {
    private init() { }
    static let shared = WeatherManager()
    typealias completion = (Weather) -> ()
    
    // MARK: - GET Current Weather Info
    
    func requestWeather(lat: Double, lon: Double, completion: @escaping completion) {
        let url = EndPoint.weatherURL + "lat=\(lat)&lon=\(lon)&appid=" + APIKey.WEATHER + "&units=metric"
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let weather = Weather(icon: String.makeIconURL(json["weather"][0]["icon"].stringValue),
                                      description: json["weather"][0]["description"].stringValue,
                                      wind: json["wind"]["speed"].doubleValue,
                                      humidity: json["main"]["humidity"].intValue,
                                      temp: json["main"]["temp"].intValue,
                                      tempMax: json["main"]["temp_max"].intValue,
                                      tempMin: json["main"]["temp_min"].intValue)
                completion(weather)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
