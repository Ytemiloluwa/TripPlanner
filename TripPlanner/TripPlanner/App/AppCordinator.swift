//
//  AppCordinator.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import UIKit

class AppCoordinator {
    private var window: UIWindow?
    private var navigationController: UINavigationController?

    func start(in window: UIWindow) {
        self.window = window
        
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
