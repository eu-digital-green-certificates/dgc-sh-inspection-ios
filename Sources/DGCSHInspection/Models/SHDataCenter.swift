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
    // private static let trustListLoader: TrustedListLoader = TrustedListLoader()
    
    public static var certStrings: [SHCertString] {
        get {
            return shDataManager.localData.certStrings
        }
        set {
            shDataManager.localData.certStrings = newValue
        }
    }
    
    public static var lastFetch: Date {
        get {
            return shDataManager.localData.lastFetch
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
            if #available(iOS 15, *) {
                if lastFetch < Date.now {
                    TrustedListLoader.loadTrustedList { response in
                        completion(response)
                    }
                }
            } else {
                // Fallback on earlier versions
                if lastFetch.timeIntervalSince1970 < Date().timeIntervalSince1970 {
                    TrustedListLoader.loadTrustedList { response in
                        completion(response)
                    }
                }
            }
            completion(.success)
        }
    }
    
    static func reloadWalletData(completion: @escaping DataCompletionHandler) {
        // relod all kid data
        TrustedListLoader.loadTrustedList { response in
            completion(response)
        }
    }
    
    static func initializeWalletLocalData(completion: @escaping DataCompletionHandler) {
        shDataManager.loadLocalData { data in
            completion(.success)
        }
    }
}
