//
//  Environment+live.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxSwift
import RxCocoa

// MAK - App

extension AppEnvironment {
	static var live = Self(
		stargazersEnv: StargazerViewEnvironment.live
	)
}

// MARK: - View (features composition)

extension StargazerViewEnvironment {
	static var live = Self(
		stargazersEnv: StargazersEnvironment.live
	)
}

// MARK: - Single feature

extension StargazersEnvironment {
	static var live = Self(
		fetch: { owner, repo, page in
			let request = StargazerRequest(
				owner: owner,
				repo: repo,
				page: page
			)
			
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
				.catchError { (e: Error) -> Observable<[StargazersModel]> in
					guard let error = e as? APIError else {
						return .just([])
					}
					
					switch error {
					case let .code(value):
						if case .NotFound = value {
							return .just([
								.notFound
							])
						}
						
						return .just([])
					default:
						return .just([])
					}
				}
		}
	)
}
