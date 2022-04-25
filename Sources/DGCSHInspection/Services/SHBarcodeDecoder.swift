//
//  SMDecoder.swift
//  
//
//  Created by Paul Ballmann on 10.04.22.
//

import Foundation
import DGCCoreLibrary

class SHBarcodeDecoder {
    private static let shcIdent = "shc:/"
    
    public static func builder(payload: String) throws -> String {
        let rawBarcode = payload.replacingOccurrences(of: shcIdent, with: "")
        var numericCode: String = ""
        var index = rawBarcode.startIndex
        while numericCode.count <= (rawBarcode.count / 2) - 1 {
            guard let numVal = Int(rawBarcode[index..<rawBarcode.index(index, offsetBy: 2)])
            else {
                throw CertificateParsingError.parsing(errors: [])
            }
            numericCode.append("\(UnicodeScalar(UInt8(numVal + 45)))")
            index = rawBarcode.index(index, offsetBy: 2)
        }
        return numericCode
    }
}
