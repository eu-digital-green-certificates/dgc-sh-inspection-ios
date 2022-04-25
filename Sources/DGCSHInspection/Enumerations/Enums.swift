//
//  Enums.swift
//  
//
//  Created by Paul Ballmann on 13.04.22.
//

import Foundation

public enum SHCertType: String {
    case immunization = "immunization"
    case other = "other"
    
    init(value: String) {
        if let type = SHCertType(rawValue: value) {
            self = type
        } else {
            self = .other
        }
    }
}

public enum SHParsingError: Error {
    case unknown
    case invalidStructure
    case kidNotIncluded
    case kidNotFound(untrustedUrl: String)
    case issuerNotIncluded
    case timeBeforeNBF
    case credentialExpired
}

