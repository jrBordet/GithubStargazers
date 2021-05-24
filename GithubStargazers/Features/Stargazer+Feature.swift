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
		return [
			environment.fetch(state.owner, state.repo, state.currentPage).map { StargazersAction.fetchResponse($0) }
		]
	case let .fetchResponse(result):
		state.isLoading = false

		guard result.isEmpty == false else {
			return []
		}
		
		state.list = result
		state.currentPage = state.currentPage + 1
		
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
	static var empty = Self(
		name: "",
		imageUrl: nil
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
	case fetch
	case fetchResponse([StargazersModel])
}

// MARK: - Environment

public struct StargazersEnvironment {
	var fetch: (String, String, Int) -> Effect<[StargazersModel]>
}

