//
//  SceneDelegate.swift
//  RSSFeed App (VIPER)
//
//  Created by Tsibulko on 02.08.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }

		let initialVC = NewsAssembly().makeNewsModule()
		let window = UIWindow(windowScene: windowScene)
		window.rootViewController = initialVC
		self.window = window
		window.makeKeyAndVisible()
	}
}
