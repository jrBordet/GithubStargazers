//
//  Environment+live.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation

extension AppEnvironment {
	static var live = Self(
		stargazersEnv: StargazerViewEnvironment.live
	)
}

extension StargazerViewEnvironment {
	static var live = Self(
		stargazersEnv: StargazersEnvironment.live
	)
}

extension StargazersEnvironment {
	static var live = Self(
		fetch: { owner, repo, page in
			let request = StargazerRequest(
				owner: "octocat",
				repo: "hello-world",
				page: 1
			)
			
			return request
				.execute(with: URLSession.shared)
				.map { (model: [StargazerRequestModel]) -> [StargazersModel] in
					model.map { (m: StargazerRequestModel) -> StargazersModel in
						StargazersModel(
							name: m.login,
							imageUrl: URL(string: m.avatar_url)
						)
					}
				}
		}
	)
}

extension StargazersEnvironment {
	static var mock = Self(
		fetch: { _, _, page in
			let request = StargazerRequest(
				owner: "octocat",
				repo: "hello-world",
				page: page
			)
			
			return request
				.execute(with: URLSession.shared)
				.map { (model: [StargazerRequestModel]) -> [StargazersModel] in
					model.map { (m: StargazerRequestModel) -> StargazersModel in
						StargazersModel(
							name: m.login,
							imageUrl: URL(string: m.avatar_url)
						)
					}
				}
		}
	)
}
