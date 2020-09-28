//
//  SearchVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 27/09/2020.
//

import UIKit

// MARK: - SearchVC
class SearchVC: UIViewController {
    var model = Model()
    var state: SearchVCState = .archived
    var archivedItems: [String] = []
    var searchedItems: SearchedItems?
    
    enum SearchVCState {
        case archived
        case searching
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    
    // MARK: - private methods
    private func viewSetup() {
        self.model.delegate = self
        
        self.searchBar.delegate = self
        self.searchBar.hideSmallClearButton()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        hideKeyboardWhenTappedAround()
    }
    
    private func viewUpdate() {
        self.tableView.reloadData()
    }
    
    // MARK: - @IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - @IBActions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        searchBar.text = ""
        self.searchedItems = nil
        self.state = .archived
        self.viewUpdate()
    }
    
}
// MARK: - SearchVC extensions
extension SearchVC: ModelDelegate {
    func searchedItemsFetched(_ searchedItems: SearchedItems) {
        self.searchedItems = searchedItems
        viewUpdate()
    }
    func playListItemsFetched(_ playListItems: PlayListItems) {}
}

extension SearchVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.state = .searching
        self.viewUpdate()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count != 0 else {
            self.state = .archived
            self.viewUpdate()
            return
        }
        switch self.state {
        case .archived:
            self.state = .searching
            break
        case .searching:
            let keyWords: String = searchText.replacingOccurrences(of: " ", with: "+")
            self.model.getSearchList(q: keyWords, maxResults: 15)
            break
        }
        self.viewUpdate()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let item = self.searchBar.text, !item.isEmpty, !self.archivedItems.contains(item) {
            self.archivedItems.append(item)
            
            presentSearchResultVC()
        }
    }
}
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.state {
        case .archived:
            return self.archivedItems.count
        case .searching:
            return self.searchedItems?.items.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.state {
        case .archived:
            var reversedItems = self.archivedItems
            reversedItems.reverse()
            let title = reversedItems[indexPath.row]
            let cell = self.tableView.dequeueReusableCell(withIdentifier: SearchTVC().identifier, for: indexPath) as! SearchTVC
            cell.setItem(withTitle: title)
            return cell
        case .searching:
            let title = self.searchedItems?.items[indexPath.row].snippet.title
            let cell = self.tableView.dequeueReusableCell(withIdentifier: SearchTVC().identifier, for: indexPath) as! SearchTVC
            cell.setItem(withTitle: title ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.state {
        case .archived:
            let title = self.archivedItems[indexPath.row]
            self.searchBar.text = title
            break
        case .searching:
            let title = self.searchedItems?.items[indexPath.row].snippet.title
            self.searchBar.text = title
            if !self.archivedItems.contains(title!) {
                self.archivedItems.append(title!)
            }
            break
        }
        presentSearchResultVC()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var deleteAction: UIContextualAction {
            let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
                self.archivedItems.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
            }
            action.title = "Delete"
            action.backgroundColor = .red
            return action
        }
        switch self.state {
        case .archived:
            return UISwipeActionsConfiguration(actions: [deleteAction])
        case .searching:
            return nil
        }
    }
}
