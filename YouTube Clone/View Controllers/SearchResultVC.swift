//
//  SearchResultVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 28/09/2020.
//

import UIKit

class SearchResultVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
