//
//  UiTextField+Extension.swift
//  Tracker
//
//  Created by Bakhadir on 15.03.2024.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
