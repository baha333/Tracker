//
//  CategoryStoreError.swift
//  Tracker
//
//  Created by Bakhadir on 08.04.2024.
//

import Foundation

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidTrackers
    case failedToInitializeTracker
    case failedToFetchCategory
}
