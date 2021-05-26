//
//  StargazersTests.swift
//  GithubStargazersTests
//
//  Created by Jean Raphael Bordet on 24/05/21.
//

import XCTest
@testable import GithubStargazers
import Difference
import RxComposableArchitecture
import RxSwift
import RxCocoa
import RxComposableArchitectureTests
import SnapshotTesting

class StargazersViewTests: XCTestCase {
	let env_empty = StargazerViewEnvironment(
		stargazersEnv: StargazersEnvironment(
			fetch: { _, _, _ in
				.just([])
			}
		)
	)
	
	let env_filled = StargazerViewEnvironment(
		stargazersEnv: StargazersEnvironment(
			fetch: { _, _, page in
				if page == 1 {
					return .just([
						.sample
					])
				} else if page == 2 {
					return .just([
						.sample_1
					])
				} else {
					return .just([])
				}
			}
		)
	)
	
	let env_not_found = StargazerViewEnvironment(
		stargazersEnv: StargazersEnvironment(
			fetch: { _, _, _ in
				.just([
					.notFound
				])
			}
		)
	)
	
	override func setUp() {
	}
	
	override func tearDown() {
	}
	
	func testStargazersSearch_owner_repo() {
		assert(
			initialValue: .empty,
			reducer: stargazerViewReducer,
			environment: env_filled,
			steps: Step(.send, StargazerViewAction.search(.owner("octocat")), { state in
				state.owner = "octocat"
			}), Step(.send, StargazerViewAction.search(.repo("hello-world")), { state in
				state.repo = "hello-world"
			}),
			Step(.send, StargazerViewAction.stargazer(StargazersAction.fetch), { state in
				state.isLoading = true
			}),
			Step(.receive, StargazerViewAction.stargazer(StargazersAction.fetchResponse([.sample])), { state in
				state.isLoading = false
				state.currentPage = 2
				state.list = [
					.sample
				]
			}),
			Step(.send, StargazerViewAction.stargazer(StargazersAction.fetch), { state in
				state.isLoading = true
			}),
			Step(.receive, StargazerViewAction.stargazer(StargazersAction.fetchResponse([.sample_1])), { state in
				state.isLoading = false
				state.currentPage = 3
				state.list = [
					.sample,
					.sample_1
				]
			})
		)
	}
	
	func testStargazersFetch_owner_repo() {
		assert(
			initialValue: .empty,
			reducer: stargazerViewReducer,
			environment: env_filled,
			steps: Step(.send, StargazerViewAction.stargazer(.owner("octocat")), { state in
				state.owner = "octocat"
			}), Step(.send, StargazerViewAction.stargazer(.repo("hello-world")), { state in
				state.repo = "hello-world"
			}),
			Step(.send, StargazerViewAction.stargazer(StargazersAction.fetch), { state in
				state.isLoading = true
			}),
			Step(.receive, StargazerViewAction.stargazer(StargazersAction.fetchResponse([.sample])), { state in
				state.isLoading = false
				state.currentPage = 2
				state.list = [
					.sample
				]
			}),
			Step(.send, StargazerViewAction.stargazer(StargazersAction.fetch), { state in
				state.isLoading = true
			}),
			Step(.receive, StargazerViewAction.stargazer(StargazersAction.fetchResponse([.sample_1])), { state in
				state.isLoading = false
				state.currentPage = 3
				state.list = [
					.sample,
					.sample_1
				]
			})
		)
	}
	
	func testStargazersFetch_empty_owner_and_repo() {
		assert(
			initialValue: .empty,
			reducer: stargazerViewReducer,
			environment: env_empty,
			steps: Step(.send, StargazerViewAction.stargazer(StargazersAction.fetch), { state in
				state.isLoading = true
				state.list = []
			})
		)
	}
	
	func testStargazersFetch_empty_owner_empty() {
		let initialValue = StargazerViewState(
			list: [],
			   repo: "some",
			   owner: "",
			   isLoading: false,
			   alert: "",
			   currentPage: 0
		   )
		
		assert(
			initialValue: initialValue,
			reducer: stargazerViewReducer,
			environment: env_empty,
			steps: Step(.send, StargazerViewAction.stargazer(StargazersAction.fetch), { state in
				state.isLoading = true
				state.list = []
			})
		)
	}
	
	func testStargazersFetch_not_found() {
		let initialValue = StargazerViewState(
			list: [],
			   repo: "some",
			   owner: "bob",
			   isLoading: false,
			   alert: "",
			   currentPage: 0
		   )
		
		assert(
			initialValue: initialValue,
			reducer: stargazerViewReducer,
			environment: env_not_found,
			steps: Step(.send, StargazerViewAction.stargazer(StargazersAction.fetch), { state in
				state.isLoading = true
			}), Step(.receive, StargazerViewAction.stargazer(StargazersAction.fetchResponse([.notFound])), { state in
				state.isLoading = false
				state.currentPage = 0
				state.list = []
				
				state.alert = "not found"
			})
		)
	}
	
}
