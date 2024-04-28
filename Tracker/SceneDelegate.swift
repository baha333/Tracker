//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Bakhadir on 13.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let appPreferences: AppPreferencesProtocol = AppPreferences.shared

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
        if(appPreferences.isNeedShowOnboarding()) {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.onboardingCompletionHandler = { [weak self] in
                self?.appPreferences.onboardingShowed()
                
                let tabBarController = TabBarController()
                self?.window?.rootViewController = tabBarController
            }
            window?.rootViewController = onboardingViewController
            
        } else {
            let tabBarController = TabBarController()
            window?.rootViewController = tabBarController
        }
        window?.makeKeyAndVisible()
    }

}
