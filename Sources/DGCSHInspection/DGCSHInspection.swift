//
//  DGCSHInspection.swift
//  
//
//  Created by Paul Ballmann on 18.04.22.
//

import Foundation
import DGCCoreLibrary

public final class DGCSHInspection: CertificateValidating {
    public var lastUpdate: Date
    
    public var downloadedDataHasExpired: Bool {
        return SHDataCenter.downloadedDataHasExpired
    }

    public func updateLocallyStoredData(appType: AppType, completion: @escaping DataCompletionHandler) {
        switch appType {
        case .verifier:
            SHDataCenter.prepareWalletLocalData(completion: completion)
        case .wallet:
            SHDataCenter.reloadWalletData(completion: completion)
        }
    }
    
    public func validateCertificate(_ certificate: CertificationProtocol) -> ValidityState? {
        guard let _ = certificate as? SHCert else { return nil }
        
        return ValidityState(technicalValidity: VerificationResult.valid, issuerValidity: VerificationResult.valid, destinationValidity: VerificationResult.valid, travalerValidity: VerificationResult.valid, allRulesValidity: VerificationResult.valid, validityFailures: [], infoSection: nil, isRevoked: false)
    }
    
    public func prepareLocallyStoredData(appType: AppType, completion: @escaping DataCompletionHandler) {
        switch appType {
        case .verifier:
            SHDataCenter.prepareWalletLocalData(completion: completion)
        case .wallet:
            SHDataCenter.prepareWalletLocalData(completion: completion)
        }
    }
    
    public init() {
        self.lastUpdate = Date()
    }
}
