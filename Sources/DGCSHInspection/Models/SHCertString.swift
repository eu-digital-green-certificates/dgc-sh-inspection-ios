//
//  SHCertString.swift
//  
//
//  Created by Paul Ballmann on 18.04.22.
//

import Foundation

public class SHCertString: Codable {
    public let date: Date
    public let certString: String
    public var cert: SHCert? {
        return try? SHCert(payload: certString)
    }
    
    public init(date: Date, certString: String) {
        self.certString = certString
        self.date = date
    }
}
