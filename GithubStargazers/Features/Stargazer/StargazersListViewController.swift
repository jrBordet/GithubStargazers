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
}

class StargazersListViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var ownerField: UITextField!
	@IBOutlet var repoField: UITextField!
	
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
	
	@objc func addTapped() {
		store?.send(StargazerViewAction.stargazer(StargazersAction.fetch))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let store = self.store else {
			return
		}
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
		let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

		navigationItem.rightBarButtonItems = [add]

		// MARK: - Config cell
		
		tableView.rowHeight = 56
		tableView.separatorColor = .clear
		
		registerTableViewCell(
			with: tableView,
			cell: StargazerCell.self,
			reuseIdentifier: "StargazerCell"
		)
		
		tableView.separatorColor = .lightGray
		
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
			.debug("[StargazersListViewController] currentPage", trimOutput: false)
			.map { $0 > 0 }
			.filter { $0 }
			.bind(to: store.rx.fetch)
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
				insertAnimation: .bottom,
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
