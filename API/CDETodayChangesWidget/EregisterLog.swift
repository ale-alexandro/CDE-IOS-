//
//  EregisterLog.swift
//  API
//
//  Created by 4lex@ndr0 on 10/03/2019.
//  Copyright © 2019 LenTech. All rights reserved.
//

import Foundation

class EregisterLog {
    private var log: NSArray
    
    public let count: Int
    
    init(rawJsonData: NSArray)
    {
        self.log = rawJsonData;
        self.count = log.count
    }
    
    func getProtocol() -> NSArray {
        return log
    }
    
    func getProtocolElement(num: Int) -> NSDictionary {
        return log[num] as! NSDictionary
    }
}
