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
	
	static var sample = Self(
		stargazersEnv: StargazerViewEnvironment.sample
	)
}

// MARK: - View (features composition)

extension StargazerViewEnvironment {
	static var live = Self(
		stargazersEnv: StargazersEnvironment.live
	)
	
	static var sample = Self(
		stargazersEnv: StargazersEnvironment.sample
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
						
						return .just([])s
					default:
						return .just([])
					}
				}
		}
	)
	
	static var sample = Self(
		fetch: { _, _, _ in
			.just([
				StargazersModel.sample,
				.sample_1
			])
		}
	)
}

//			request
//				.execute()
//				.catchError { (e: Error) -> Observable<[StargazerRequestModel]> in
//					guard let error = e as? APIError else {
//						return .just([])
//					}
//
//					switch error {
//					case let .code(value):
//						return .just([])
//					default:
//						return .just([])
//					}
//				}
//				.subscribe()
//				.retryWhen { e -> Observable<[StargazerRequestModel]> in
//					e.enumerated().flatMap { (index: Int, element: Error) -> Observable<[StargazerRequestModel]> in
//						if let error = element as? APIError {
//							dump(error)
//							switch error {
//							case let .code(value):
//								return .just([])
//							default:
//								return .just([])
//							}
//						}
//
//						return .just([])
//					}
//				}.subscribe()

/**

let request = StargazerRequest(
owner: "octocat",
repo: "hello-world",
page: page
)

*/
