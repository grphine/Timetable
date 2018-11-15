//
//  UIColor+Hex.swift
//  timetable
//
//  Created by Juheb on 15/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a) //built-in call that returns values between 0 and 1 for each channel
        
        return String(
            format: "%02X%02X%02X", //converted into three hex strings (using %02X - display an integer in upper-case base 16, with 0-padding up to 2 digits)
            Int(r * 0xff), //normalise into value between 0 and 255
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}

    
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue) //convert 6 char string to hex int
        
        let r = (rgbValue & 0xff0000) >> 16 //bitmasked and bitshifted to produce values
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff, //divided by hex 255 to turn back into val between 0-1, compatible with uicolor
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}


