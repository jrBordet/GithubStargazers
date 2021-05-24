//
//  StargazerRequest.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation

public struct StargazerRequestModel: Codable {
	public let id: Int
	public let login: String
	public let avatar_url: String
}

extension StargazerRequestModel: Equatable {
}

/// Refrences https://docs.github.com/en/rest/reference/activity#starring
/// Example:
/// [Url ecample](https://api.github.com/repos/octocat/hello-world/stargazers)
/// Mon Nov 20 2017 17:30:00 GMT+0100
///
/// - Parameters:
///   - page: the page index
/// - Returns: a collection of StargazerRequestModel

public struct StargazerRequest: APIRequest, CustomDebugStringConvertible {
	public var debugDescription: String {
		request.debugDescription
	}
	
	public typealias Response = [StargazerRequestModel]
	
	public var endpoint: String = "stargazers"
	
	private (set) var owner: String
	private (set) var repo: String
	private (set) var page: Int
	
	public var request: URLRequest? {
		guard let url = URL(string: "https://api.github.com/repos/\(owner)/\(repo)/\(endpoint)?page=\(page)") else {
			return nil
		}
		
		var request = URLRequest(url: url)
		request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
		request.httpMethod = "GET"
				
		return request
	}
	
	public init(
		owner: String,
		repo: String,
		page: Int = 1
	) {
		self.owner = owner
		self.repo = repo
		self.page = page
	}
}


/**


{
	"login": "ryagas",
	"id": 553981,
	"node_id": "MDQ6VXNlcjU1Mzk4MQ==",
	"avatar_url": "https://avatars.githubusercontent.com/u/553981?v=4",
	"gravatar_id": "",
	"url": "https://api.github.com/users/ryagas",
	"html_url": "https://github.com/ryagas",
	"followers_url": "https://api.github.com/users/ryagas/followers",
	"following_url": "https://api.github.com/users/ryagas/following{/other_user}",
	"gists_url": "https://api.github.com/users/ryagas/gists{/gist_id}",
	"starred_url": "https://api.github.com/users/ryagas/starred{/owner}{/repo}",
	"subscriptions_url": "https://api.github.com/users/ryagas/subscriptions",
	"organizations_url": "https://api.github.com/users/ryagas/orgs",
	"repos_url": "https://api.github.com/users/ryagas/repos",
	"events_url": "https://api.github.com/users/ryagas/events{/privacy}",
	"received_events_url": "https://api.github.com/users/ryagas/received_events",
	"type": "User",
	"site_admin": false
},

*/
