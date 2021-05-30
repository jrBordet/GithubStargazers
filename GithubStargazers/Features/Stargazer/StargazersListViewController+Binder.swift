//
//  StargazersListViewController+Binder.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 30/05/21.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxComposableArchitecture
import SceneBuilder

extension Reactive where Base: Store<StargazerViewState, StargazerViewAction> {
	var fetch: Binder<(Bool)> {
		Binder(self.base) { store, value in
			store.send(StargazerViewAction.stargazer(StargazersAction.fetch))
		}
	}
	
	var owner: Binder<(String)> {
		Binder(self.base) { store, value in
			store.send(StargazerViewAction.stargazer(StargazersAction.owner(value)))
		}
	}
	
	var repo: Binder<(String)> {
		Binder(self.base) { store, value in
			store.send(StargazerViewAction.stargazer(StargazersAction.repo(value)))
		}
	}
}
