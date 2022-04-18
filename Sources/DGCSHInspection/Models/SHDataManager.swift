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
    
    public func add(_ cert: SHCert, completion: @escaping DataCompletionHandler) {
        localData.certStrings.append(SHCertString(date: Date(), certString: cert.payload))
        storage.save(localData, completion: completion)
    }
    
    public func remove(withDate date: Date, completion: @escaping DataCompletionHandler) {
        if let find = localData.certStrings.firstIndex(where: { $0.date == date }) {
            localData.certStrings.remove(at: find)
            storage.save(localData, completion: completion)
        }
    }
    
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
            self.localData = loadedData
            self.save(completion: completion)
        }
    }
}
