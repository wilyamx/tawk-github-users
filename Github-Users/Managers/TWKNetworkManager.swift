//
//  TWKNetworkManager.swift
//  Github-Users
//
//  Created by William S. Rena on 2/26/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation

struct TWKRequestError {
    var errorCode: Int = 0
    var errorMessage: String = ""
}

enum TWKResponse<T> {
    case succeed(T)
    case failed(TWKRequestError)
}

class TWKNetworkManager {
    static let shared = TWKNetworkManager()
    
    static let DOMAIN_URL_STRING = "https://api.github.com"
    
    // MARK: - Public Methods
    
    public func getUsers(
        lastUserId: Int32,
        completion: @escaping ([TWKGithubUserCodable]?) -> ()) {
        
        guard let url = URL(string: "https://api.github.com/users?since=1") else {
            return
        }
        
        URLSession.shared.dataTask(
            with: url,
            completionHandler: {
                data, response, error -> Void in
                    if let data = data {
                        do {
                            let jsonDecoder = JSONDecoder()
                            let responseModel = try jsonDecoder.decode([TWKGithubUserCodable].self, from: data)
                            DebugInfoKey.api.log(info: "\(responseModel)")
                            completion(responseModel)
                        }
                        catch let error {
                            DebugInfoKey.error.log(info: "JSON Serialization error :: \(error)")
                        }
                    }
            }).resume()
        
    }
    
}
