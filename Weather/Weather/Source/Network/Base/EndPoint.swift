//
//  EndPoint.swift
//  Weather
//
//  Created by heerucan on 2022/08/15.
//

import Foundation

enum EndPoint {
    static let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid=\(APIKey.WEATHER)"
}
