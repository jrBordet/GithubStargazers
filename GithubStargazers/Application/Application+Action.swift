//
//  AppAction.swift
//  GithubStargazers
//

import Foundation
import RxComposableArchitecture

enum AppAction {
	case stargazer(StargazerViewAction)
}

extension AppAction: Equatable { }
