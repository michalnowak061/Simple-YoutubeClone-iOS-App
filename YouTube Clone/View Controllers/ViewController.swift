//
//  ViewController.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 26/09/2020.
//

import UIKit

class ViewController: UIViewController {
    var model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.getPlayListItems()
    }


}

