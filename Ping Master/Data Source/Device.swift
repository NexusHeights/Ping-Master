//
//  Device.swift
//  Ping Master
//
//  Created by Gregory Stanton on 4/3/16.
//  Copyright © 2016 Nexus Heights. All rights reserved.
//
//  This is the data model of our device class, which our device list will load.
//  It is a very simple class, and it is codable and objectifiable using NSCoding and NSObject, allowing it to be
//  saved and loaded from disk

import UIKit

class Device: NSObject, NSCoding {
    
    // Setup vars
    var name: String
    var ip: String
    
    // Where we will save the device list
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("devices")
    
    // Setup properties
    struct PropertyKey
    {
    static let nameKey = "name"
    static let ipKey = "ip"
    }
    
    // Initializer for class
    init?(name: String, ip: String)
    {
        self.name = name
        self.ip = ip
        
        super.init()
        
        // Allow failing if empty name/ip is passed
        if name.isEmpty || ip.isEmpty
        {
            return nil
        }
    }
    
    // Allow encoding of object
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(ip, forKey: PropertyKey.ipKey)
    }
    
    /// Function that will encode
    required convenience init?(coder aDecoder: NSCoder)
    {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let ip = aDecoder.decodeObjectForKey(PropertyKey.ipKey) as! String
        self.init(name: name, ip: ip)
    }
}
