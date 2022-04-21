//
//  SHDataCenter.swift
//  
//
//  Created by Paul Ballmann on 18.04.22.
//

import Foundation
import DCCInspection
import DGCCoreLibrary

public class SHDataCenter {
    public static let shDataManager: SHDataManager = SHDataManager()
    
    public static var certStrings: [SHCertString] {
        get {
            return shDataManager.localData.certStrings
        }
        set {
            shDataManager.localData.certStrings = newValue
        }
    }
    
    public static func saveLocalData(completion: @escaping DataCompletionHandler) {
        shDataManager.save(completion: completion)
    }
}

// MARK: Wallet data loading
extension SHDataCenter {
    static func prepareWalletLocalData(completion: @escaping DataCompletionHandler) {
        // for more to be added
        initializeWalletLocalData { result in
            completion(.success)
        }
    }
    
    static func initializeWalletLocalData(completion: @escaping DataCompletionHandler) {
        shDataManager.loadLocalData { data in
            completion(.success)
        }
    }
}
