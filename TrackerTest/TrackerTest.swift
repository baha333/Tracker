//
//  TrackerTest.swift
//  TrackerTest
//
//  Created by Bakhadir on 08.05.2024.
//

import XCTest
import SnapshotTesting

@testable import Tracker

class TrackerTests: XCTestCase {

    func testingTrackersViewControllerLightStyle() {
            let vc = TrackersViewController()
            
            assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        }
        
        func testingTrackersViewControllerDarkStyle() {
            let vc = TrackersViewController()
            
            assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
        }
}
