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
    
    static let BASE_URL = "https://api.github.com"
    static let PAGE_SIZE = 5
    
    // MARK: - Public Methods
    
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
        completion: @escaping ([TWKGithubUserCodable]?) -> ()) {
        
        guard let url = URL(string: "\(TWKNetworkManager.BASE_URL)/users?since=\(lastUserId)&per_page=\(TWKNetworkManager.PAGE_SIZE)") else {
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
        completion: @escaping (TWKGithubUserProfileCodable?) -> ()) {
        
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
                            completion(responseModel)
                        }
                        catch let error {
                            DebugInfoKey.error.log(info: "JSON Serialization error :: \(error)")
                        }
                    }
            }).resume()
        
    }
}
