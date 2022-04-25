//
//  File.swift
//  
//
//  Created by Paul Ballmann on 22.04.22.
//

import Foundation

public class TrustedIssuerResponse: Codable {
    public let url: String
    public let type: String
    public let country: String
    public let thumbprint: String
    public let sslPublicKey: String
    public let keyStorageType: String
    public let signature: String
    public let timestamp: Date
    public let name: String

    public init(url: String, type: String, country: String, thumbprint: String, sslPublicKey: String, keyStorageType: String, signature: String, timestamp: Date, name: String) {
        self.url = url
        self.type = type
        self.country = country
        self.thumbprint = thumbprint
        self.sslPublicKey = sslPublicKey
        self.keyStorageType = keyStorageType
        self.signature = signature
        self.timestamp = timestamp
        self.name = name
    }
    
    
}
