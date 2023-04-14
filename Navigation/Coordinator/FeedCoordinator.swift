//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Андрей Банин on 19.3.23..
//

import Foundation
import UIKit

class FeedCoordinator: AppCoordinator {
    
    weak var parentCoordinator: AppCoordinator?
    
    var child: [AppCoordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFeedVC()
    }
    
    func showFeedVC() {
        let viewModel = FeedViewModel()
        let feedVC = FeedViewController()
        
        feedVC.viewModel = viewModel
        viewModel.coordinator = self
        navigationController.pushViewController(feedVC, animated: false)
    }
    
    func showPostVC() {
        let postVC = PostViewController()
        postVC.coordinator = self
        navigationController.pushViewController(postVC, animated: true)
    }
    
    func showInfoVC() {
        let infoVC = InfoViewController()
        infoVC.coordinator = self
        navigationController.pushViewController(infoVC, animated: true)
    }
}