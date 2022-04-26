//
//  File.swift
//  
//
//  Created by Igor Khomiak on 26.04.2022.
//

import Foundation
import Compression

extension Data {
    func inflateFixed() -> Data {
        let size = 1024 * 10
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        defer { buffer.deallocate() }
        return withUnsafeBytes { unsafeBytes in
            let read = compression_decode_buffer(buffer, size,
              unsafeBytes.baseAddress!.bindMemory(to: UInt8.self, capacity: 1),
              count, nil, COMPRESSION_ZLIB
            )
            return Data(bytes: buffer, count: read)
        }
    }
}
