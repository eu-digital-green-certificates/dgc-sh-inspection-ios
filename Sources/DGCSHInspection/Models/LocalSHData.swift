//
//  LocalSHData.swift
//  
//
//  Created by Paul Ballmann on 18.04.22.
//

import Foundation

public class LocalSHData: Codable {
    // public var encodedPublicKeys = [String : [String]]()
    public var certStrings = [SHCertString]()
    
    public var resumeToken: String = ""
    public var lastFetch: Date = Date.distantPast
}

