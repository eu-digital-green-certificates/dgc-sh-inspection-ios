//
//  TrustedListLoader.swift
//  
//
//  Created by Paul Ballmann on 22.04.22.
//

import Foundation
import Alamofire
import DGCCoreLibrary
import SwiftyJSON

public class TrustedListLoader {
    
    public static func loadTrustedList(completion: @escaping DataCompletionHandler) {
        var request = URLRequest(url: URL(string: "https://dgca-verifier-service-eu-test.cfapps.eu10.hana.ondemand.com/trustedissuers")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.httpBody = try! JSONSerialization.data(withJSONObject: jwts)
        AF.request(request).response {
            guard
                case .success = $0.result,
                let status = $0.response?.statusCode,
                let response = $0.data,
                status / 100 == 2
            else {
                completion(.failure(.noInputData))
                return
            }
            guard let trustedList = try? JSONDecoder().decode([TrustedIssuerResponse].self, from: response) else {
                completion(.failure(.encodindFailure))
                return
            }
            var kidList: [String:String] = [:] // kid: jwks
            // var counter = 0
            let trustListGroup = DispatchGroup()
            for trustedElement in trustedList {
                trustListGroup.enter()
                if trustedElement.keyStorageType == "JWKS" {
                    let url = transformJwksUrl(trustedElement)
                    if url.isEmpty {
                        trustListGroup.leave()
                        continue
                    }
                    var request = URLRequest(url: URL(string: url)!)
                    request.httpMethod = "GET"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    AF.request(request).responseJSON { response in
                        switch response.result {
                            case .success(let value):
                            let json = JSON(value)
                            
                            if let keyList = json["keys"].array {
                                keyList.forEach { element in
                                    let kid = element["kid"]
                                    kidList[kid.stringValue] = element.rawString()
                                }
                            }
                            case .failure(let error):
                                print(error)
                            }
                        trustListGroup.leave()
                    }
                } else {
                    trustListGroup.leave()
                }
            }
            trustListGroup.notify(queue: .main) {
                SHDataCenter.shDataManager.replace(kidList) { result in
                    completion(.success)
                }
            }
        }
    }
    
    public static func resolveUnknownIssuer(_ rawUrl: String, completion: @escaping (_ kidList: [String: String]?, _ operationResult: DataOperationResult) -> ()) {
        var request = URLRequest(url: URL(string: rawUrl)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    var kidList: [String: String] = [:]
                    if let keyList = json["keys"].array {
                        keyList.forEach { element in
                            let kid = element["kid"]
                            kidList[kid.stringValue] = element.rawString()
                        }
                    }
                    SHDataCenter.shDataManager.add(kidList) { response in
                        completion(kidList, response)
                    }
                case .failure(let error):
                    completion(nil, .noData)
            }
        }
    }
    
    private static func transformJwksUrl(_ trustedElement: TrustedIssuerResponse) -> String {
        var trustedElementUrl: String = trustedElement.url
        if trustedElement.type == "HTTP" &&
            (!trustedElementUrl.hasSuffix("/.well-known/jwks.json") || !trustedElementUrl.hasSuffix(".json")) {
            trustedElementUrl = "\(trustedElement.url)/.well-known/jwks.json"
        } else if trustedElement.type == "DID" && trustedElementUrl.hasPrefix("did:web") {
            trustedElementUrl = trustedElementUrl.replacingOccurrences(of: "did:web:", with: "")
                .replacingOccurrences(of: ":", with: "/")
            if trustedElementUrl.contains("/") {
                trustedElementUrl = "https://\(trustedElementUrl)/did.json"
            } else {
                trustedElementUrl = "https://\(trustedElementUrl)/.well-known/did.json"
            }
        } else {
            return ""
        }
        return trustedElementUrl
    }
}
