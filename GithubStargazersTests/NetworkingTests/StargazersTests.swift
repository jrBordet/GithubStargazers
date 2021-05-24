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

class StargazersTestsTests: XCTestCase {
	let env = StargazerViewEnvironment(
		stargazersEnv: StargazersEnvironment(fetch: { v in
			.just([])
		}), other: {
			.just(true)
		})
	
	override func setUp() {
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testStargazersFetch() {
		assert(
			initialValue: .empty,
			reducer: stargazerViewReducer,
			environment: env,
			steps: Step(.send, StargazerViewAction.stargazer(StargazersAction.fetch), { state in
				state.isLoading = true
			}),
			Step(.receive, StargazerViewAction.stargazer(StargazersAction.fetchResponse([])), { state in
				state.isLoading = false
				state.currentPage = 1
			})
		)
	}
	
}
