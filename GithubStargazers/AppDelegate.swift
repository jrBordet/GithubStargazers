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
		
//		if let clientID = ProcessInfo.processInfo.environment["BASE_URL"] {
//			print(clientID)
//		} else {
//			fatalError()
//		}
		
		#if MOCK
			print("[MOCK]")
		#endif
		
		let rootScene = Scene<StargazersListViewController>().render()
		
		rootScene.store = applicationStore.view(
			value: { $0.starGazersFeature },
			action: { .stargazer($0) }
		)
		
		self.window?.rootViewController = UINavigationController(rootViewController: rootScene)
				
		self.window?.makeKeyAndVisible()
		self.window?.backgroundColor = .white
		
		return true
	}
}
