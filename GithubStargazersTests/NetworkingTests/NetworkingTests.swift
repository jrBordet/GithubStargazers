//
//  ArrivalsTests.swift
//  ViaggioTrenoTests
//
//  Created by Jean Raphael Bordet on 10/12/2020.
//

import XCTest
import RxBlocking
@testable import GithubStargazers

class NetworkingTests: XCTestCase {
	var urlSession: URLSession!
	
	override func setUpWithError() throws {
		let configuration = URLSessionConfiguration.ephemeral
		configuration.protocolClasses = [MockUrlProtocol.self]
		
		urlSession = URLSession(configuration: configuration)
	}
	
	override func tearDownWithError() throws {
	}
	
	func testStargazerRequest() {
		let request = StargazerRequest(
			owner: "octocat",
			repo: "hello-world"
		)
		
		XCTAssertEqual("https://api.github.com/repos/octocat/hello-world/stargazers?page=1", request.request?.url?.absoluteString)
		XCTAssertEqual("GET", request.request?.httpMethod)
		XCTAssertEqual(["Accept": "application/vnd.github.v3+json"], request.request?.allHTTPHeaderFields)
	}
	
	func testStargazerRequestPaged() {
		let request = StargazerRequest(
			owner: "octocat",
			repo: "hello-world",
			page: 2
		)
		
		XCTAssertEqual("https://api.github.com/repos/octocat/hello-world/stargazers?page=2", request.request?.url?.absoluteString)
		XCTAssertEqual("GET", request.request?.httpMethod)
		XCTAssertEqual(["Accept": "application/vnd.github.v3+json"], request.request?.allHTTPHeaderFields)
	}
	
	func testStargazerRequest_success() throws {
		let response = """
		[
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
		}
		]
		"""
		
		MockUrlProtocol.requestHandler = requestHandler(with: response.data(using: .utf8)!)
		
		
		let request = StargazerRequest(
			owner: "octocat",
			repo: "hello-world"
		)
		
		let result = try request
			.execute(with: urlSession)
			.toBlocking(timeout: 10)
			.toArray()
			.first
		
		XCTAssertFalse(result!.isEmpty)
		XCTAssertEqual(result?.first?.id, 553981)
	}
	
	func testStargazerRequest_decoding_error() throws {
		let response = """
		[
		{
		"login": "ryagas",
		"broken_id": 553981,
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
		}
		]
		"""
		
		MockUrlProtocol.requestHandler = requestHandler(with: response.data(using: .utf8)!)
		
		let request = StargazerRequest(
			owner: "octocat",
			repo: "hello-world"
		)
		
		do {
			_ = try request
				.execute(with: urlSession)
				.toBlocking(timeout: 10)
				.toArray()
				.first
		} catch let error {
			XCTAssertEqual( APIError.decoding(""), error as? APIError)
		}
	}
}
