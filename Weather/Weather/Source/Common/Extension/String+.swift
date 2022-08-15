//
//  String+.swift
//  Weather
//
//  Created by heerucan on 2022/08/16.
//

import Foundation

extension String {
    static func makeIconURL(_ icon: String) -> String {
        let iconURL = EndPoint.iconURL + icon + "@2x.png"
        return iconURL
    }
    
    func convertKorean() -> String {
        switch self {
        case "clear sky":
            return "밖에 나가기 딱 좋은 날씨네요☀️😎"
        case "few clouds":
            return "선선하니 지금 나가면 딱이네요🌤😝"
        case "scattered clouds":
            return "해가 없어서 나가기 좋네요⛅️"
        case "broken clouds":
            return "바람이 좀 부네요?☁️💨🤣🤣"
        case "shower rain":
            return "비가 좀 오네요?🌧💦😅"
        case "rain":
            return "우산 있죠..?🌧☔️☂️"
        case "thunderstorm":
            return "우르릉쾅! 집에 있쟈...⛈⚡️💥🌩"
        case "snow":
            return "눈은 볼 때가 제일 이쁜 거 알져?☃️🧤❄️"
        case "mist":
            return "안개가 짙네요🌬💨🌫"
        default:
            return "그냥 집에 있는 게 최곱니다^^🙈🙉🙊"
        }
    }
}
