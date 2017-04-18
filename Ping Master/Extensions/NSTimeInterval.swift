//
//  NSTimeInterval.swift
//  Ping Master
//
//  Created by Hunter Stanton on 9/3/16.
//
//  Copied from http://stackoverflow.com/questions/30771820/swift-convert-milliseconds-into-minutes-seconds-and-milliseconds and slightly modified to return double instead so that rounding can occur
// All credits to the original author.

import Foundation

extension NSTimeInterval
{
    // Converts seconds to milliseconds
    var millisecond: Double
    {
        return Double(self*1000 % 1000 )
    }

}
