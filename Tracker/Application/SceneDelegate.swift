
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let isFirstLaunch = UserDefaults.standard.object(forKey: Key.isFirstLaunch.rawValue)
        if isFirstLaunch != nil {
            showTrackerViewController()
        } else {
            showOnboardingScreen()
        }
    }
    
    private func showTrackerViewController() {
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    private func showOnboardingScreen() {
        let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        window?.rootViewController = pageViewController
        window?.makeKeyAndVisible()
    }
}

enum Key: String {
    case isFirstLaunch
}

