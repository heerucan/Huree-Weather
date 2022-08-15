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
}
