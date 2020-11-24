//
//  NewBetsCoordinator.swift
//  CHUGGR
//
//  Created by Daniel Luo on 11/24/20.
//

import UIKit

class NewBetsCoordinator: ChildCoordinating {
    weak var parentCoordinator: MainCoordinator?
    var childCoordinator = [ChildCoordinating]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = NewBetViewController.instantiate()
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(
            title: "New Bet",
            image: UIImage(systemName: "plus.circle.fill"),
            tag: 2
        )
        navigationController.pushViewController(vc, animated: false)
    }
}
