//
//  Search+Future.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 26/05/21.
//

import Foundation
import RxComposableArchitecture

public func searchReducer(
	state: inout SearchState,
	action: SearchAction,
	environment: SearchEnvironment
) -> [Effect<SearchAction>] {
	switch action {
	case let .owner(v):
		state.owner = v
		return []
	case let .repo(v):
		state.repo = v
		return []
	}
}

// MARK: - State

public struct SearchState  {
	var repo: String
	var owner: String
	
	public init(
		repo: String,
		owner: String
	) {
		self.repo = repo
		self.owner = owner
	}
}

extension SearchState {
	static var empty = Self(
		repo: "",
		owner: ""
	)
}

// MARK: - Action

public enum SearchAction: Equatable {
	case owner(String)
	case repo(String)
}

// MARK: - Environment

public struct SearchEnvironment {
}
