//
//  File.swift
//  
//
//  Created by Paul Ballmann on 18.04.22.
//

import Foundation
import DGCCoreLibrary
import DCCInspection

public final class SHInspection: CertificateInspection {
    public var lastUpdate: Date
    
    public func updateLocallyStoredData(appType: AppType, completion: @escaping DataCompletionHandler) {
        switch appType {
        case .verifier:
            break
        case .wallet:
            SHDataCenter.reloadWalletData(completion: completion)
        }
    }
    
    public func validateCertificate(_ certificate: CertificationProtocol) -> VerifyingProtocol {
        return ValidityState(technicalValidity: VerificationResult.valid, issuerValidity: VerificationResult.valid, destinationValidity: VerificationResult.valid, travalerValidity: VerificationResult.valid, allRulesValidity: VerificationResult.valid, validityFailures: [], infoSection: nil, isRevoked: false)
    }
    
    public func prepareLocallyStoredData(appType: AppType, completion: @escaping DataCompletionHandler) {
        switch appType {
        case .verifier:
            break
        case .wallet:
            SHDataCenter.prepareWalletLocalData(completion: completion)
        }
    }
    
    public init() {
        self.lastUpdate = Date()
    }
}
