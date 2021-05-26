//
//  Stargazer+Feature.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxComposableArchitecture

public func stargazerReducer(
	state: inout StargazersState,
	action: StargazersAction,
	environment: StargazersEnvironment
) -> [Effect<StargazersAction>] {
	switch action {
	case .fetch:
		state.isLoading = true
		
		guard state.owner.isEmpty == false && state.repo.isEmpty == false else {
			state.list = []
			
			return []
		}
		
		return [
			environment.fetch(state.owner, state.repo, state.currentPage).map { StargazersAction.fetchResponse($0) }
		]
	case let .fetchResponse(result):
		state.isLoading = false

		guard result.isEmpty == false else {
			return []
		}
		
		if result == [.notFound] {
			state.alert = "not found"
			state.currentPage = 1
			state.list = []
			return []
		} else {
			state.alert = nil
		}
		
		state.list.append(contentsOf: result)
		state.currentPage = state.currentPage + 1
		
		return []
	case let .owner(v):
		state.currentPage = 1
		state.list = []
		
		state.owner = v
		return []
	case let .repo(v):
		state.currentPage = 1
		state.list = []
		
		state.repo = v
		return []
	case .purge:
		state.list = []
		state.isLoading = false
		state.alert = nil
		state.currentPage = 1
		
		return []
	}
}

// MARK: - Model

public struct StargazersModel {
	let name: String
	let imageUrl: URL?
}

extension StargazersModel: Equatable { }

extension StargazersModel {
	static var notFound = Self(
		name: "not-found",
		imageUrl: nil
	)
	
	static var empty = Self(
		name: "",
		imageUrl: nil
	)
	
	static var sample = Self(
		name: "ryagas",
		imageUrl: URL(string: "https://avatars.githubusercontent.com/u/553981?v=4")!
	)
	
	static var sample_1 = Self(
		name: "kjaikeerthi",
		imageUrl: URL(string: "https://avatars.githubusercontent.com/u/351510?v=4")!
	)
}

// MARK: - State

public struct StargazersState  {
	var list: [StargazersModel]
	var repo: String
	var owner: String
	var isLoading: Bool
	var alert: String?
	var currentPage: Int
	
	public init(
		list: [StargazersModel],
		repo: String,
		owner: String,
		isLoading: Bool,
		alert: String?,
		currentPage: Int = 1
	) {
		self.list = list
		self.repo = repo
		self.owner = owner
		self.isLoading = isLoading
		self.alert = alert
		self.currentPage = currentPage
	}
}

extension StargazersState {
	static var empty = Self(
		list: [],
		repo: "",
		owner: "",
		isLoading: false,
		alert: nil
	)
}

// MARK: - Action

public enum StargazersAction: Equatable {
	case purge
	case fetch
	case fetchResponse([StargazersModel])
	case owner(String)
	case repo(String)
}

// MARK: - Environment

public struct StargazersEnvironment {
	/// Lists the people that have starred the repository.
	///
	/// ```
	/// fetch("octocat", "hello-world", 2)
	/// ```
	///
	/// - Parameter owner: a `String`
	/// - Parameter repo: a `String`
	/// - Parameter page: a `Int`
	/// - Returns:  a collection of `StargazersModel`.
	var fetch: (String, String, Int) -> Effect<[StargazersModel]>
}

