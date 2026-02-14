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
    private let tripService = TripService()
    
    func start(in window: UIWindow) {
        self.window = window
        
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let tripListVC = createTripListViewController()
        navigationController.setViewControllers([tripListVC], animated: false)
    }
    
    private func createTripListViewController() -> UIViewController {
        let viewModel = TripListViewModel(
            tripService: tripService,
            coordinator: self
        )
        return TripListViewController(viewModel: viewModel)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
