//
//  Stargazer+View.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import Foundation
import RxComposableArchitecture

public struct StargazerViewState: Equatable {
	public var list: [StargazersModel]
	public var repo: String
	public var owner: String
	public var isLoading: Bool
	public var alert: String?
	public var currentPage: Int
	
	public init(
		list: [StargazersModel],
		repo: String,
		owner: String,
		isLoading: Bool,
		alert: String?,
		currentPage: Int
	) {
		self.list = list
		self.repo = repo
		self.owner = owner
		self.isLoading = isLoading
		self.alert = alert
		self.currentPage = currentPage
	}
	
	var stargazer: StargazersState {
		get {
			StargazersState(
				list: self.list,
				repo: self.repo,
				owner: self.owner,
				isLoading: self.isLoading,
				alert: self.alert,
				currentPage: currentPage
			)
		}
		
		set {
			self.list = newValue.list
			self.repo = newValue.repo
			self.owner = newValue.owner
			self.isLoading = newValue.isLoading
			self.alert = newValue.alert
			self.currentPage = newValue.currentPage
		}
	}
}

extension StargazerViewState {
	static var empty = Self(
		list: [],
		repo: "",
		owner: "",
		isLoading: false,
		alert: nil,
		currentPage: 1
	)
	
	static var sample = Self(
		list: [],
		repo: "octocat",
		owner: "hello-world",
		isLoading: false,
		alert: nil,
		currentPage: 1
	)
	
	static var test = Self(
		list: [
			StargazersModel.sample,
			StargazersModel.sample_1
		],
		repo: "octocat",
		owner: "hello-world",
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
}

public let stargazerViewReducer: Reducer<StargazerViewState, StargazerViewAction, StargazerViewEnvironment> = combine(
	pullback(
		stargazerReducer,
		value: \StargazerViewState.stargazer,
		action: /StargazerViewAction.stargazer,
		environment: { $0.stargazersEnv }
	)
)
