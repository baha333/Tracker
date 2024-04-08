//
//  CategoryStoreError.swift
//  Tracker
//
//  Created by Bakhadir on 08.04.2024.
//

import Foundation

enum CategoryStoreError: Error {
    case decodingTitleError
    case decodingTrackersError
    case fetchingCategoryError
}
