//
//  Weather.swift
//  Weather
//
//  Created by heerucan on 2022/08/16.
//

import Foundation

struct Weather {
    let icon, description: String
    let wind: Double
    let humidity, temp, tempMax, tempMin: Int
    
    var tempLabel: String {
        return "현재 온도는 \(temp)°"
    }
    
    var maxMinLabel: String {
        return "최고 \(tempMax)°  최저 \(tempMin)°"
    }
    
    var humidityLabel: String {
        return "현재 습도는 \(humidity)% 입니다."
    }
    
    var windLabel: String {
        return "현재 풍속은 \(wind)m/s 입니다."
    }
    
    var descriptionLabel: String {
        return description.convertKorean()
    }
}
