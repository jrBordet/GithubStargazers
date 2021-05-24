//
//  AppAction.swift
//  GithubStargazers
//

import Foundation
import RxComposableArchitecture

enum AppAction {
	case stargazer(StargazerViewAction)
}

public struct StargazerViewState: Equatable {
	public var list: [StargazersModel]
	public var isLoading: Bool
	public var alert: String?
	public var currentPage: Int
	
	public init(
		list: [StargazersModel],
		isLoading: Bool,
		alert: String?,
		currentPage: Int
	) {
		self.list = list
		self.isLoading = isLoading
		self.alert = alert
		self.currentPage = currentPage
	}
	
	var stargazer: StargazersState {
		get {
			StargazersState(
				list: self.list,
				isLoading: self.isLoading,
				alert: self.alert,
				currentPage: currentPage
			)
		}
		
		set {
			self.list = newValue.list
			self.isLoading = newValue.isLoading
			self.alert = newValue.alert
			self.currentPage = newValue.currentPage
		}
	}
}

extension StargazerViewState {
	static var empty = Self(
		list: [],
		isLoading: false,
		alert: nil,
		currentPage: 1
	)
}

public enum StargazerViewAction: Equatable {
	case stargazer(StargazersAction)
}

public struct StargazerViewEnvironment {
	var stargazersEnv: StargazersEnvironment
	var other: () -> Effect<Bool>
}

public let stargazerViewReducer: Reducer<StargazerViewState, StargazerViewAction, StargazerViewEnvironment> = combine(
	pullback(
		stargazerReducer,
		value: \StargazerViewState.stargazer,
		action: /StargazerViewAction.stargazer,
		environment: { $0.stargazersEnv }
	)
)

// MARK: - Stargazer Reducer

public func stargazerReducer(
	state: inout StargazersState,
	action: StargazersAction,
	environment: StargazersEnvironment
) -> [Effect<StargazersAction>] {
	switch action {
	case .fetch:
		state.isLoading = true
		return [
			environment.fetch(state.currentPage).map { StargazersAction.fetchResponse($0) }
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

// MARK: - State

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

public struct StargazersState  {
	var list: [StargazersModel]
	var isLoading: Bool
	var alert: String?
	var currentPage: Int
	
	public init(
		list: [StargazersModel],
		isLoading: Bool,
		alert: String?,
		currentPage: Int = 1
	) {
		self.list = list
		self.isLoading = isLoading
		self.alert = alert
		self.currentPage = currentPage
	}
}

extension StargazersState {
	static var empty = Self(
		list: [],
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
	var fetch: (Int) -> Effect<[StargazersModel]>
}

