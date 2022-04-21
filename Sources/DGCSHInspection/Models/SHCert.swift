//
//  HCert.swift
//  
//
//  Created by Paul Ballmann on 09.04.22.
//

import Foundation
import DGCCoreLibrary
import SwiftyJSON
import Sextant
import DCCInspection
import SWCompression
import Compression

public class SHCert: CertificationProtocol, Codable {
	public var cryptographicallyValid: Bool = true
	public var isRevoked: Bool = false
	public var certTypeString: String = ""
	public var certHash: String = ""
	public var uvciHash: Data?
	public var countryCodeUvciHash: Data?
	public var signatureHash: Data?
    public let fullPayloadString: String
	public let payload: String
	
	public var firstName: String {
        var targetString = ""
        var rawNameArray = get("$.vc..name..given.*").array!
        rawNameArray.forEach { elem in
            targetString += elem.string!.replacingOccurrences(of: "[]\n", with: "") + " "
        }
        return targetString
	}
    
    public var prettyBody: String {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: payload.data(using: .utf8)!, options: [])
            let jsonRawString: String
            if #available(iOS 13.0, *) {
                guard let jrs = String(data: try JSONSerialization.data(withJSONObject: jsonObject, options: [.withoutEscapingSlashes, .prettyPrinted]), encoding: .utf8) else {
                    return ""
                }
                jsonRawString = jrs
            } else {
                guard let jrs = String(data: try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]), encoding: .utf8) else {
                    return ""
                }
                jsonRawString = jrs.replacingOccurrences(of: #""\""#, with: "")
            }
            return jsonRawString
        } catch {
            return ""
        }
    }
	
	public var lastName: String {
        return get("$.vc..name..family")[0].string ?? ""
	}
	
	public var firstNameStandardized: String {
        return firstName.uppercased()
	}
	
	public var lastNameStandardized: String {
		return lastName.uppercased()
	}
	
	public var fullName: String {
		return "\(firstName)\(lastName)"
	}
	
	public var dates: [JSON] {
        return get("$.vc..occurrenceDateTime").array ?? []
    }
	
	public var issuer: String {
        guard let rawArray = get("$.vc..actor.display").array,
              let actor = rawArray.last else {
            return ""
        }
        return actor.string ?? ""
    }
    
    public var body: JSON {
        guard let rawArray = get("$.vc.credentialSubject.fhirBundle").array else {
            return JSON("")
        }
        return JSON(rawArray)
    }
	
	public var type: SHCertType {
        guard let rawArray = get("$.vc..type.*").array,
              let rawType = rawArray[1].string else {
            return .other
        }
        return SHCertType(value: rawType.replacingOccurrences(of: "https://smarthealth.cards#", with: ""))
    }
    
    public var subType: String {
        guard let rawArray = get("$.vc..type.*").array,
              let rawType = rawArray[2].string else {
            return ""
        }
        return rawType.replacingOccurrences(of: "https://smarthealth.cards#", with: "")
    }
    
	public var dateOfBirth: String {
        return get("$.vc..birthDate").array?.first?.string ?? ""
    }
     
	public required init(payload: String, ruleCountryCode: String? = nil) throws {
        // self.body = JSON(payload)
        self.fullPayloadString = payload
        guard let barcode = try? SHBarcodeDecoder.builder(payload: payload) else {
            throw CertificateParsingError.parsing(errors: [])
        }
        
        let barcodeParts = barcode.split(separator: ".")
        guard let header = String(barcodeParts[0]).base64UrlDecoded() else {
            throw CertificateParsingError.unknown
        }

        let payload = String(barcodeParts[1]).base64UrlToBase64()
        let compressedData = Data(base64Encoded: payload)!
        let jsonData = compressedData.inflateFixed()
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
        let jsonRawString: String
        if #available(iOS 13.0, *) {
            guard let jrs = String(data: try JSONSerialization.data(withJSONObject: jsonObject, options: [.withoutEscapingSlashes]), encoding: .utf8) else {
                throw CertificateParsingError.unknown
            }
            jsonRawString = jrs
        } else {
            guard let jrs = String(data: try JSONSerialization.data(withJSONObject: jsonObject, options: []), encoding: .utf8) else {
                throw CertificateParsingError.unknown
            }
            // let string2 = jrs.stringByReplacingOccurrencesOfString(#"\"#, withString: "")
            jsonRawString = jrs.replacingOccurrences(of: #""\""#, with: "")
        }
        self.payload = jsonRawString
    }
	
	private func get(_ key: String) -> JSON {
        if let query = payload.query(values: key),
           let jsonQuery = try? JSONSerialization.data(withJSONObject: query),
           let jsonData = try? JSON(data: jsonQuery) {
            return jsonData
        }
        return JSON("")
	}
    
    private func transformBase64Url(payload: String) -> Data {
        var str = payload
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if str.count % 4 != 0 {
            str.append(String(repeating: "=", count: 4 - str.count % 4))
        }
        if let data = Data(base64Encoded: str, options: .ignoreUnknownCharacters) {
            return data
        }
        
        return Data()
        
    }
}

extension Data {
    func inflateFixed() -> Data {
        let size = 1024 * 10
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        defer { buffer.deallocate() }
        return withUnsafeBytes { unsafeBytes in
          let read = compression_decode_buffer(
            buffer, size,
            unsafeBytes.baseAddress!.bindMemory(to: UInt8.self, capacity: 1),
            count, nil, COMPRESSION_ZLIB
          )
          return Data(bytes: buffer, count: read)
        }
    }
}

extension String {
    func base64UrlToBase64() -> String {
        var str = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if str.count % 4 != 0 {
            str.append(String(repeating: "=", count: 4 - str.count % 4))
        }
        return str
    }
    func base64UrlDecoded() -> String? {
        var str = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if str.count % 4 != 0 {
            str.append(String(repeating: "=", count: 4 - str.count % 4))
        }
        if let data = Data(base64Encoded: str, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

