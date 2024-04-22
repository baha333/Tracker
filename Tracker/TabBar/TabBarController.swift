//
//  TabBarController.swift
//  Tracker
//
//  Created by Bakhadir on 16.03.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSeparator()
        generateTabBar()
    }
    
    //MARK: - Private Functions
    private func addSeparator() {
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        separator.backgroundColor = .ypGray
        tabBar.addSubview(separator)
    }
    
    private func generateTabBar() {
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Trackers"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Statistics"),
            selectedImage: nil
        )
        
        viewControllers = [trackersViewController, statisticsViewController]
    }
}