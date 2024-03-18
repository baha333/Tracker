//
//  TabBarController.swift
//  Tracker
//
//  Created by Bakhadir on 16.03.2024.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = .white
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .white
            UITabBar.appearance().standardAppearance = tabBarAppearance
            
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
        setupTabs()
    }
    
    private func setupTabs() {
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "trackerTabBarActive"),
            selectedImage: nil
        )
        let navViewController = UINavigationController(rootViewController: trackerViewController)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statTabBar"),
            selectedImage: nil)
        
        self.viewControllers = [navViewController, statisticsViewController]
    }
}
