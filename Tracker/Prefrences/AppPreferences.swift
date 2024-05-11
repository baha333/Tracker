import Foundation

protocol AppPreferencesProtocol {
    
    func isNeedShowOnboarding() -> Bool
    
    func onboardingShowed()
}

class AppPreferences: AppPreferencesProtocol {
    
    static let shared = AppPreferences()
    
    private static let keyNeedShowOnboarding = "keyNeedShowOnboarding"
    
    private let defaults = UserDefaults.standard
    
    private init() {
    }
    
    func isNeedShowOnboarding() -> Bool {
        defaults.object(forKey: AppPreferences.keyNeedShowOnboarding) as? Bool ?? true
    }
    
    func onboardingShowed() {
        defaults.set(false, forKey: AppPreferences.keyNeedShowOnboarding)
    }
}
