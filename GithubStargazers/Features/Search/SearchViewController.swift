//
//  SearchViewController.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 26/05/21.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxComposableArchitecture

extension Reactive where Base: Store<SearchState, SearchAction> {
	var owner: Binder<(String)> {
		Binder(self.base) { store, value in
			store.send(SearchAction.owner(value))
		}
	}
	
	var repo: Binder<(String)> {
		Binder(self.base) { store, value in
			store.send(SearchAction.repo(value))
		}
	}
}

class SearchViewController: UIViewController {
	@IBOutlet var confirmButton: UIButton!
	@IBOutlet var purgeButton: UIButton!
	
	@IBOutlet var ownerField: UITextField!
	@IBOutlet var repoField: UITextField!
	
	// MARK: Store
	
	public var store: Store<SearchState, SearchAction>?
	
	private let disposeBag = DisposeBag()
	
	public var closeClosure: (() -> Void)?
	
	// MARK: - Life cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Search"
		
		guard let store = self.store else {
			return
		}
		
		confirmButton.rx
			.tap
			.bind { [weak self] in
				if let close = self?.closeClosure {
					close()
				}
				
				self?.dismiss(animated: true, completion: nil)
			}.disposed(by: disposeBag)
		
		store.value
			.map { $0.owner }
			.bind(to: self.ownerField.rx.text)
			.disposed(by: disposeBag)
		
		store.value
			.map { $0.repo }
			.bind(to: self.repoField.rx.text)
			.disposed(by: disposeBag)
		
		purgeButton.rx
			.tap
			.bind {
				store.send(SearchAction.owner(""))
				store.send(SearchAction.repo(""))
			}.disposed(by: disposeBag)
		
		// MARK: - owner
		
		ownerField.rx
			.text
			.map { $0 ?? "" }
			.bind(to: store.rx.owner)
			.disposed(by: disposeBag)
		
		// MARK: - repo
		
		repoField.rx
			.text
			.map { $0 ?? "" }
			.bind(to: store.rx.repo)
			.disposed(by: disposeBag)
	}
}
