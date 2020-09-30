//
//  UIViewController.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 28/09/2020.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentSearchResultVC(barTitle: String, model: Model) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchResultVC = storyboard.instantiateViewController(withIdentifier: "SearchResultVC") as! SearchResultVC
        
        searchResultVC.barTitle = barTitle
        searchResultVC.model = model
        
        searchResultVC.modalPresentationStyle = .fullScreen
        searchResultVC.modalTransitionStyle = .crossDissolve
        
        present(searchResultVC, animated: false, completion: nil)
    }
}
