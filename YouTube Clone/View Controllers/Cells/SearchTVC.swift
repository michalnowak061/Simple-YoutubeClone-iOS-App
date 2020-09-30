//
//  SearchTVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 27/09/2020.
//

import UIKit

class SearchTVC: UITableViewCell {
    let identifier = "SearchTVC"

    public func setSearch(withTitle: String) {
        self.icon.image = UIImage(named: "SF_magnifyingglass_circle_fill")
        self.titleLabel.text = withTitle
    }
    
    public func setArchivedSearch(withTitle: String) {
        self.icon.image = UIImage(named: "SF_archivebox_fill")
        self.titleLabel.text = withTitle
    }
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
}
