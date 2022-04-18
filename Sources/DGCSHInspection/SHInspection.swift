//
//  File.swift
//  
//
//  Created by Paul Ballmann on 18.04.22.
//

import Foundation
import DGCCoreLibrary

public final class SHInspection {
    public func prepareLocallyStoredData(appType: AppType, completion: @escaping DataCompletionHandler) {
        switch appType {
        case .verifier:
            break
        case .wallet:
            SHDataCenter.prepareWalletLocalData(completion: completion)
        }
    }
}
