//
//  ConfigureUIForTrackerCreationProtocol.swift
//  Tracker
//
//  Created by Bakhadir on 18.03.2024.
//

import Foundation

protocol ConfigureUIForTrackerCreationProtocol: AnyObject {
    func configureButtonsCell(cell: ButtonsCell)
    func setUpBackground()
    func calculateTableViewHeight(width: CGFloat) -> CGSize
    func checkIfSaveButtonCanBePressed()
}
