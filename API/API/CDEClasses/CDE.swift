//
//  CDE.swift
//  API
//
//  Created by 4lex@ndr0 on 19/02/2019.
//  Copyright © 2019 LenTech. All rights reserved.
//

import Foundation
import UIKit

public enum CDEError: Error {
    case ConnectionProblems
    case LoginEmpty
    case PasswordEmpty
    case WrongLoginPass
}

class CDESession
{
    private var password : String
    
    public let session = URLSession.shared
    public let DEDomain = "https://de.ifmo.ru/"
    public let eregister = "api/private/eregister"
    
    public var login : String
    
    init(login : String, passwd : String) throws {
        let login_method = self.DEDomain + "servlet/?Rule=LOGON&LOGIN="+login+"&PASSWD="+passwd
        self.login = login
        self.password = passwd
        
        if (self.login == "") {
            throw CDEError.LoginEmpty
        }
        else if (self.password == "") {
            throw CDEError.PasswordEmpty
        }
        
        guard let url = URL(string: login_method) else { return }
        
        let semaphore = DispatchSemaphore(value: 0)
        self.session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            semaphore.signal()
        }.resume() // Get auth token
        semaphore.wait()
        
        
    }
}


