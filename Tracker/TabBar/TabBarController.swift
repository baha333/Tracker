import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = traitCollection.userInterfaceStyle == .light ? UIColor.ypGray.cgColor : UIColor.black.cgColor
        UITabBar.appearance().tintColor = .ypBlue
        UITabBar.appearance().unselectedItemTintColor = .ypGray
        let normalColor = UIColor.ypGray
        let selectedColor = UIColor.ypBlue
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: normalColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
    
        self.viewControllers = [setTrackersViewController(), setStatisticsViewController()]
    }

    func setTrackersViewController() -> UINavigationController {
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: "trackers.title".localized,
            image: UIImage(named: "tab_trackers"),
            selectedImage: nil)
        return UINavigationController(rootViewController: trackersViewController)
    }

    func setStatisticsViewController() -> UINavigationController {
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "statistics.title".localized,
            image:  UIImage(named: "tab_statistics"),
            selectedImage: nil)
       
        return UINavigationController(rootViewController: statisticsViewController)
    }
}

