//
//  AppReducer.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 03/08/2020.
//

import Foundation
import RxComposableArchitecture
import RxSwift

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =  combine(
	pullback(
		stargazerViewReducer,
		value: \AppState.starGazers,
		action: /AppAction.stargazer,
		environment: { $0.stargazersEnv }
	)
)
