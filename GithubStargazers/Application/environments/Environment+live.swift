//
//  Environment+live.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxSwift
import RxCocoa

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
		fetch: { repo, owner, page in
			let request = StargazerRequest(
				owner: owner,
				repo: repo,
				page: page
			)
			
			request
				.execute()
				.retryWhen { e -> Observable<Bool> in
					
					
					return .just(true)
				}
			
			return request
				.execute(with: URLSession.shared)
				.map { (model: [StargazerRequestModel]) -> [StargazersModel] in
					model.map { (m: StargazerRequestModel) -> StargazersModel in
						let model = StargazersModel(
							name: m.login,
							imageUrl: URL(string: m.avatar_url)
						)
						
						return model
					}
				}
		}
	)
}

/**

let request = StargazerRequest(
	owner: "octocat",
	repo: "hello-world",
	page: page
)

*/
