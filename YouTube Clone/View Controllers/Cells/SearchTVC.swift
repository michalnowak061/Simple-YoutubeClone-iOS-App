//
//  SearchTVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 27/09/2020.
//

import UIKit

class SearchTVC: UITableViewCell {
    let identifier = "SearchTVC"

    public func setItem(withTitle: String) {
        self.titleLabel.text = withTitle
    }
    
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
}
