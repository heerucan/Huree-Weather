//
//  UIView+.swift
//  Weather
//
//  Created by heerucan on 2022/08/15.
//

import UIKit

extension UIView {
    func makeRound(_ radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
    func makeBorder(_ width: CGFloat) {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = width
    }
}
