//
//  UISearchBar.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 28/09/2020.
//

import UIKit

extension UISearchBar {
    func hideSmallClearButton() {
        let textField: UITextField = self.value(forKey: "_searchField") as! UITextField
        textField.clearButtonMode = .never
    }
}
