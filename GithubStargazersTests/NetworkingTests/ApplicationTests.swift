//
//  ApplicationTests.swift
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

class ApplicationTests: XCTestCase {
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testApplication() throws {
		let mock = StargazerViewEnvironment(
			stargazersEnv:
				StargazersEnvironment(
					fetch: { _, _, _ in
						.just([
							.sample
						])
					}
				)
		)
		
		assert(
			initialValue: AppState(starGazers: StargazerViewState.empty),
			reducer: appReducer,
			environment: AppEnvironment(stargazersEnv: mock),
			steps: Step(.send, AppAction.stargazer(StargazerViewAction.stargazer(StargazersAction.owner("octocat"))), { state in
				state.starGazers.owner = "octocat"
			}), Step(.send, AppAction.stargazer(StargazerViewAction.stargazer(StargazersAction.repo("hello-world"))), { state in
				state.starGazers.repo = "hello-world"
			}),	Step(.send, AppAction.stargazer(StargazerViewAction.stargazer(StargazersAction.fetch)), { state in
				state.starGazers.isLoading = true
			}), Step(.receive, AppAction.stargazer(StargazerViewAction.stargazer(StargazersAction.fetchResponse([StargazersModel.sample]))), { state in
				state.starGazers.isLoading = false
				
				state.starGazers.currentPage = 2
				
				state.starGazers.list = [
					StargazersModel.sample
				]
			})
		)
	}
	
}
