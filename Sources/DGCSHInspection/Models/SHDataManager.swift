//
//  SHDataManager.swift
//  
//
//  Created by Paul Ballmann on 18.04.22.
//

import Foundation
import DGCCoreLibrary

public class SHDataManager {
    lazy var storage = SecureStorage<LocalSHData>(fileName: SharedSHConstants.shDataStorageName)
    var localData = LocalSHData()
    
    // MARK: Certificates
    public func add(_ cert: SHCert, completion: @escaping DataCompletionHandler) {
        localData.certStrings.append(SHCertString(date: Date(), certString: cert.fullPayloadString))
        storage.save(localData, completion: completion)
    }
    
    public func remove(withDate date: Date, completion: @escaping DataCompletionHandler) {
        if let find = localData.certStrings.firstIndex(where: { $0.date == date }) {
            localData.certStrings.remove(at: find)
            storage.save(localData, completion: completion)
        }
    }
    
    // MARK: Trusted Issuer Lists
    public func replace(_ trustedIssuer: [String: String], completion: @escaping DataCompletionHandler) {
        localData.kidList = trustedIssuer // overwrite old kidList
        localData.lastFetch = Date()
        storage.save(localData, completion: completion)
    }
    
    public func add(_ trustedIssuer: [String: String], completion: @escaping DataCompletionHandler) {
        localData.kidList.merge(trustedIssuer) { (current, _) in current }
        storage.save(localData, completion: completion)
    }
    
    public func containsKid(_ kidStr: String) -> Bool {
        return (localData.kidList.firstIndex(where: { $0.key == kidStr }) != nil)
    }
    
    public func getJwkByKid(_ kidStr: String) -> String? {
        let jwk = localData.kidList[kidStr]
        return jwk
    }
    
    // MARK: Aux
    public func save(completion: @escaping DataCompletionHandler) {
        storage.save(localData, completion: completion)
    }
    
    public func loadLocalData(completion: @escaping DataCompletionHandler) {
        storage.loadStoredData(fallback: localData) { [unowned self] data in
            guard let loadedData = data else {
                completion(.failure(DataOperationError.noInputData))
                return
            }
            
            let format = "%d shcerts loaded"
            DGCLogger.logInfo(String(format: format, loadedData.certStrings.count))
            let trustlistFormat = "%d trustlist elements loaded"
            DGCLogger.logInfo(String(format: trustlistFormat, loadedData.kidList.count))
            self.localData = loadedData
            self.save(completion: completion)
        }
    }
}
