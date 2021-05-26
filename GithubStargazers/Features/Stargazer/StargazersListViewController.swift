//
//  StargazersListViewController.swift
//  GithubStargazers
//
//  Created by Jean Raphael Bordet on 25/05/21.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import RxComposableArchitecture
import SceneBuilder

extension Store: ReactiveCompatible {}

// MARK: - RxDataSource models

struct StargazerSectionItem {
	var name: String
	var imageUrl: URL?
}

extension StargazerSectionItem: IdentifiableType {
	public typealias Identity = String
	
	public var identity: String {
		return "\(name)"
	}
}

extension StargazerSectionItem: Equatable { }

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

class StargazersListViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var ownerField: UITextField!
	@IBOutlet var repoField: UITextField!
	@IBOutlet var notFoundLabel: UILabel!
	
	// MARK: Store
	
	public var store: Store<StargazerViewState, StargazerViewAction>?
	
	// MARK: - RxDataSource
	
	typealias ArrivalsDeparturesListSectionModel = AnimatableSectionModel<String, StargazerSectionItem>
	
	var dataSource: RxTableViewSectionedAnimatedDataSource<ArrivalsDeparturesListSectionModel>!
	
	private let disposeBag = DisposeBag()
	
	static let startLoadingOffset: CGFloat = 20.0

	static func isNearTheBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
		let height = tableView.frame.size.height
		let contentYoffset = tableView.contentOffset.y
		let distanceFromBottom = tableView.contentSize.height - contentYoffset
		
		return distanceFromBottom < height
		//return contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height
	}
		
	// MARK: - Life cycle
	
	@objc func searchTapped() {
		let searchScene = Scene<SearchViewController>().render()
		
		/**
		rootScene.store = applicationStore.view(
			value: { $0.starGazersFeature },
			action: { .stargazer($0) }
		
		*/
		
		searchScene.store = self.store?.view(
			value: { $0.search },
			action: { .search($0) }
		)
		
		searchScene.closeClosure = { [weak self] in
			self?.store?.send(StargazerViewAction.stargazer(StargazersAction.purge))

			self?.store?.send(StargazerViewAction.stargazer(StargazersAction.fetch))
		}
		
		self.navigationController?.present(searchScene, animated: true, completion: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
				
//		self.store?.send(StargazerViewAction.stargazer(StargazersAction.fetch))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = L10n.App.name
		
		guard let store = self.store else {
			return
		}
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(searchTapped))
		let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))

		navigationItem.rightBarButtonItems = [search]

		// MARK: - Config cell
		
		tableView.rowHeight = 64
		tableView.separatorColor = .clear
		
		registerTableViewCell(
			with: tableView,
			cell: StargazerCell.self,
			reuseIdentifier: "StargazerCell"
		)
		
		tableView.separatorColor = .lightGray
		
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
		
		// MARK: - Load next page when table is near the bottom
		
		tableView.rx
			.contentOffset
			.skip(3) // TODO: - check this
			.distinctUntilChanged()
			.map { (offset: CGPoint) -> Bool in
				StargazersListViewController.isNearTheBottomEdge(contentOffset: offset, self.tableView)
			}
			.distinctUntilChanged()
			.flatMapLatest { v -> Observable<Int> in
				guard v else {
					return .empty()
				}
				
				return store.value.map { $0.currentPage }
			}
			.distinctUntilChanged()
			.map { $0 > 0 }
			.filter { $0 }
			.bind(to: store.rx.fetch)
			.disposed(by: disposeBag)
		
		// MARK: - not found
		
		let alert = store.value
			.map { $0.alert }
			.map { $0?.isEmpty == false }
			.share(replay: 1, scope: .whileConnected)
		
		alert
			.bind(to: notFoundLabel.rx.isVisible)
			.disposed(by: disposeBag)
		
		alert
			.bind(to: tableView.rx.isHidden)
			.disposed(by: disposeBag)

		// MARK: - Bind dataSource
		
		setupDataSource()
		
		store
			.value
			.map { (state: StargazerViewState) -> [StargazerSectionItem] in
				state.list.map { (model: StargazersModel) -> StargazerSectionItem in
					StargazerSectionItem(
						name: model.name,
						imageUrl: model.imageUrl
					)
				}
			}
			.map { (items: [StargazerSectionItem]) -> [ArrivalsDeparturesListSectionModel] in
				[
					ArrivalsDeparturesListSectionModel(
						model: "",
						items: items
					)
				]
			}
			.asDriver(onErrorJustReturn: [])
			.drive(tableView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
	}
	
	// MARK: - Data Source Configuration
	
	private func setupDataSource() {
		dataSource = RxTableViewSectionedAnimatedDataSource<ArrivalsDeparturesListSectionModel>(
			animationConfiguration: AnimationConfiguration(
				insertAnimation: .none,
				reloadAnimation: .none
			),
			configureCell: configureCell
		)
	}
	
}

// MARK: - cell

extension StargazersListViewController {
	private var configureCell: RxTableViewSectionedAnimatedDataSource<ArrivalsDeparturesListSectionModel>.ConfigureCell {
		return { _, table, idxPath, item in
			guard let cell = table.dequeueReusableCell(withIdentifier: "StargazerCell", for: idxPath) as? StargazerCell else {
				return UITableViewCell(style: .default, reuseIdentifier: nil)
			}
			
			cell.nameLabel.text = item.name.lowercased()
			
			if let url = item.imageUrl {
				cell.avatarImage?.load(url: url)
			}
			
			return cell
		}
	}
}
