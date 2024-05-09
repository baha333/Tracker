import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.onboardingCompletionHandler = { [weak self] in
            let tabBarController = TabBarController()
            self?.window?.rootViewController = tabBarController
        }
        window?.rootViewController = onboardingViewController
        window?.makeKeyAndVisible()
        
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "da10504e-8cbb-4c70-ac03-a9c37fe1cc6f") else {
            return true
        }
            
        YMMYandexMetrica.activate(with: configuration)
        return true
    }
    
    // MARK: - Core Data
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Tracker")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    assertionFailure("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()

    func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
