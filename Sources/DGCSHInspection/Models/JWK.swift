//
//  JWK.swift
//  
//
//  Created by Paul Ballmann on 29.04.22.
//

import Foundation

class JWK {
  public static func ecFrom(x numX: String, y numY: String) -> SecKey? {
    var xBytes: Data?
    var yBytes: Data?
    if (numX + numY).count == 128 {
      xBytes = Data(hexString: numX)
      yBytes = Data(hexString: numY)
    } else {
      var xStr = numX // Base64 Formatted data
      var yStr = numY

      xStr = xStr.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
      while xStr.count % 4 != 0 {
        xStr.append("=")
      }
      yStr = yStr.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
      while yStr.count % 4 != 0 {
        yStr.append("=")
      }
      xBytes = Data(base64Encoded: xStr)
      yBytes = Data(base64Encoded: yStr)
    }

    // Now this bytes we have to append such that [0x04 , /* xBytes */, /* yBytes */]
    // Initial byte for uncompressed y as Key.
    let keyData = NSMutableData.init(bytes: [0x04], length: 1)
    keyData.append(xBytes ?? Data())
    keyData.append(yBytes ?? Data())
    let attributes: [String: Any] = [
      String(kSecAttrKeyType): kSecAttrKeyTypeEC,
      String(kSecAttrKeyClass): kSecAttrKeyClassPublic,
      String(kSecAttrKeySizeInBits): 256,
      String(kSecAttrIsPermanent): false
    ]
    var error: Unmanaged<CFError>?
    let keyReference = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error)
      let errorString = error?.takeUnretainedValue().localizedDescription ?? "Something went wrong.".localized
    error?.release()
    guard let key = keyReference else {
        print(errorString)
        return nil
    }

    return key
  }
}
