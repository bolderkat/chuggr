//
//  VideosCoordinator.swift
//  CHUGGR
//
//  Created by Daniel Luo on 11/24/20.
//

import UIKit
import Firebase

class VideosCoordinator: ChildCoordinating {
    weak var parentCoordinator: MainCoordinator?
    var childCoordinator = [ChildCoordinating]()
    let navigationController: UINavigationController
    let firestoreHelper: FirestoreHelper
    
    init(navigationController: UINavigationController,
         firestoreHelper: FirestoreHelper) {
        self.navigationController = navigationController
        self.firestoreHelper = firestoreHelper
        
        // Configure nav controller appearance
        self.navigationController.navigationBar.barTintColor = UIColor(named: K.colors.orange)
        self.navigationController.navigationBar.isTranslucent = false
        self.navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        navigationController.navigationBar.tintColor = .white
    }
    
    func start() {
        let vc = VideosViewController(viewModel: VideosViewModel(firestoreHelper: firestoreHelper))
        vc.coordinator = self
        vc.tabBarItem = UITabBarItem(
            title: "Videos",
            image: UIImage(systemName: "video.fill"),
            tag: 3
        )
        navigationController.pushViewController(vc, animated: false)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func openBetDetail(withBetID id: BetID) {
        let vm = BetDetailViewModel(firestoreHelper: firestoreHelper)
        vm.setBetDocID(withBetID: id)
        let vc = BetDetailViewController(viewModel: vm)
        vc.coordinator = self

        navigationController.pushViewController(vc, animated: true)
    }
}
