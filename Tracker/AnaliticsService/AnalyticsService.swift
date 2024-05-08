//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Bakhadir on 08.05.2024.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    func report(event: String, params: [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("PERORT ERROR: %@", error.localozedDescription)
        })
    }
}
