//
//  TWKNetworkManager.swift
//  Github-Users
//
//  Created by William S. Rena on 2/26/21.
//  Copyright © 2021 Tawk.to. All rights reserved.
//

import Foundation

// https://donaldhays.com/2014/12/16/enum-errors-in-swift/

enum TWKNetworkRequestError: Error {
    case noInternet
    case httpError(statusCode: Int)
    case serverError(message: String)
    case serializationError(message: String)
    
    private var errorCode: Int {
        switch self {
        case .noInternet: return 100
        case .httpError(_): return 101
        case .serverError(_): return 102
        case .serializationError(_): return 103
        }
    }
    
    var description: String {
        switch self {
        case .noInternet:
            return "There is no internet connection."
        case .httpError(let statusCode):
            return "The call failed with HTTP code \(statusCode)."
        case .serverError(let message):
            return "The server responded with message \"\(message)\"."
        case .serializationError(let message):
            return "JSON Serialization error :: \(message)"
       }
   }
}

enum TWKNetworkRequestResult<T> {
    case success(T)
    case failure(TWKNetworkRequestError)
}

class TWKNetworkManager: WSRNetworkMonitor {
    
    static let shared = TWKNetworkManager()
    
    static let BASE_URL = "https://api.github.com"
    
    // MARK: - GitHub APIs
    
    /*
     [
       {
         "login": "octocat",
         "id": 1,
         "node_id": "MDQ6VXNlcjE=",
         "avatar_url": "https://github.com/images/error/octocat_happy.gif",
         "gravatar_id": "",
         "url": "https://api.github.com/users/octocat",
         "html_url": "https://github.com/octocat",
         "followers_url": "https://api.github.com/users/octocat/followers",
         "following_url": "https://api.github.com/users/octocat/following{/other_user}",
         "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
         "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
         "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
         "organizations_url": "https://api.github.com/users/octocat/orgs",
         "repos_url": "https://api.github.com/users/octocat/repos",
         "events_url": "https://api.github.com/users/octocat/events{/privacy}",
         "received_events_url": "https://api.github.com/users/octocat/received_events",
         "type": "User",
         "site_admin": false
       }
     ]
     */
    public func getUsers(
        lastUserId: Int32,
        pageSize: Int,
        completion: @escaping (TWKNetworkRequestResult<[TWKGithubUserCodable]?>) -> ()) {
        
        var urlString = "\(TWKNetworkManager.BASE_URL)/users?since=\(lastUserId))"
        if pageSize > 0 {
            urlString = "\(urlString)&per_page=\(pageSize)"
        }
        guard let url = URL(string: urlString) else {
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
                            completion(TWKNetworkRequestResult.success(responseModel))
                        }
                        catch let error {
                            completion(TWKNetworkRequestResult.failure(.serializationError(message: error.localizedDescription)))
                        }
                    }
            }).resume()
        
    }
    
    /*
     {
       "login": "defunkt",
       "id": 2,
       "node_id": "MDQ6VXNlcjI=",
       "avatar_url": "https://avatars.githubusercontent.com/u/2?v=4",
       "gravatar_id": "",
       "url": "https://api.github.com/users/defunkt",
       "html_url": "https://github.com/defunkt",
       "followers_url": "https://api.github.com/users/defunkt/followers",
       "following_url": "https://api.github.com/users/defunkt/following{/other_user}",
       "gists_url": "https://api.github.com/users/defunkt/gists{/gist_id}",
       "starred_url": "https://api.github.com/users/defunkt/starred{/owner}{/repo}",
       "subscriptions_url": "https://api.github.com/users/defunkt/subscriptions",
       "organizations_url": "https://api.github.com/users/defunkt/orgs",
       "repos_url": "https://api.github.com/users/defunkt/repos",
       "events_url": "https://api.github.com/users/defunkt/events{/privacy}",
       "received_events_url": "https://api.github.com/users/defunkt/received_events",
       "type": "User",
       "site_admin": false,
       "name": "Chris Wanstrath",
       "company": null,
       "blog": "http://chriswanstrath.com/",
       "location": null,
       "email": null,
       "hireable": null,
       "bio": "🍔",
       "twitter_username": null,
       "public_repos": 107,
       "public_gists": 273,
       "followers": 21146,
       "following": 210,
       "created_at": "2007-10-20T05:24:19Z",
       "updated_at": "2019-11-01T21:56:00Z"
     }
     */
    public func getUserProfile(
        username: String,
        completion: @escaping (TWKNetworkRequestResult<TWKGithubUserProfileCodable?>) -> ()) {
        
        guard let url = URL(string: "\(TWKNetworkManager.BASE_URL)/users/\(username)") else {
            return
        }
        
        URLSession.shared.dataTask(
            with: url,
            completionHandler: {
                data, response, error -> Void in
                    if let data = data {
                        do {
                            let jsonDecoder = JSONDecoder()
                            let responseModel = try jsonDecoder.decode(TWKGithubUserProfileCodable.self, from: data)
                            DebugInfoKey.api.log(info: "\(responseModel)")
                            completion(TWKNetworkRequestResult.success(responseModel))
                        }
                        catch let error {
                            completion(TWKNetworkRequestResult.failure(.serializationError(message: error.localizedDescription)))
                        }
                    }
            }).resume()
        
    }
}
