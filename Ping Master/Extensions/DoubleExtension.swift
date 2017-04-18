//
//  DoubleExtension.swift
//  Ping Master
//
//  Created by Gregory Stanton on 4/25/16.
//

import Foundation

// Extend Double to allow for rounding to custom decimal places
// This function comes from:
// http://stackoverflow.com/questions/27338573/rounding-a-double-value-to-x-number-of-decimal-places-in-swift
// All credits to the original author.
extension Double
{
    
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double
    {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
    
}
