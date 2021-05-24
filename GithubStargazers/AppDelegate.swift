//
//  AppDelegate.swift
//  AlarmsDemo
//
//  Created by Jean Raphael Bordet on 17/05/2020.
//  Copyright © 2020 Jean Raphael Bordet. All rights reserved.
//

import UIKit
import RxComposableArchitecture
import SceneBuilder
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		//FirebaseApp.configure()
		
		if let clientID = ProcessInfo.processInfo.environment["BASE_URL"] {
			print(clientID)
		} else {
			fatalError()
		}
		
		#if MOCK
			print("[MOCK]")
		#endif
		
		let request = StargazerRequest(
			owner: "octocat",
			repo: "hello-world"
		)

		let result = try request
			.execute(with: URLSession.shared)
			.catchErrorJustReturn([])
			.subscribe(onNext: { value in
				dump(value)
			})
		
//		let rootScene = Scene<HomeTabViewController>().render()
//
//		rootScene.store = applicationStore.view(
//			value: { $0.homeState },
//			action: { .home($0) }
//		)
		
//		self.window?.rootViewController = UINavigationController(rootViewController: rootScene)
		
		self.window?.rootViewController = UINavigationController(rootViewController: UIViewController())
		
		self.window?.makeKeyAndVisible()
		self.window?.backgroundColor = .white
		
		return true
	}
}

struct Factory {
//	static var stations: StationsViewController = Scene<StationsViewController>().render()
	
	//	static func stations(with store: Store<AppState, AppAction>) -> StationsViewController {
	//		let vc = Scene<StationsViewController>().render()
	//
	//		vc.store = store.view(
	//			value: { $0.stations },
	//			action: { .stations($0) }
	//		)
	//
	//		return vc
	//	}
}
