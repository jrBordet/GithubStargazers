//
//  AppState.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 22/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import Foundation
import RxComposableArchitecture
import os.log

public struct AppState {
	var starGazers: StargazerViewState
}

extension AppState: Equatable { }

extension AppState {
	var starGazersFeature: StargazerViewState {
		get {
			self.starGazers
		}
		set {
			self.starGazers = newValue
		}
	}
}

let initialAppState = AppState(
	starGazers: .empty
)
