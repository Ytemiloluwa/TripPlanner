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

    func showCitySelection(completion: @escaping (String) -> Void) {
        let storyboard = UIStoryboard(name: "CitySelection", bundle: .main)
        guard
            let nav = storyboard.instantiateInitialViewController() as? UINavigationController,
            let cityVC = nav.viewControllers.first as? CitySelectionViewController
        else { return }

        cityVC.onSelect = { city in
            completion(city)
        }

        navigationController?.topViewController?.present(nav, animated: true)
    }

    func showDateSelection(start: Date, end: Date, completion: @escaping (Date, Date) -> Void) {
        let vc = DateSelectionViewController()
        vc.initialStartDate = start
        vc.initialEndDate = end
        vc.onChoose = { newStart, newEnd in
            completion(newStart, newEnd)
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        navigationController?.topViewController?.present(nav, animated: true)
    }
}
