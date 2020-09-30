//
//  SearchVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 27/09/2020.
//

import UIKit

// MARK: - SearchVC
class SearchVC: UIViewController {
    var state: SearchVCState = .archived
    var model = Model()
    var search: Search? = nil
    var archivedSearch: [String] = []
    
    enum SearchVCState {
        case archived
        case searching
        case searchingCompleted
        case selected
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    
    // MARK: - private methods
    private func viewSetup() {
        self.loadArchivedSearch()
        self.model.delegate = self
        
        self.searchBar.delegate = self
        self.searchBar.hideSmallClearButton()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        hideKeyboardWhenTappedAround()
    }
    
    private func viewUpdate() {
        self.tableView.reloadData()
        self.saveArchivedSearch()
        print("Status: \(self.state)")
    }
    
    private func saveArchivedSearch() {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documentsDirectoryPathString + "/archivedSearch"
        self.archivedSearch.saveToFile(path: path)
    }
    
    private func loadArchivedSearch() {
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = documentsDirectoryPathString + "/archivedSearch"
        self.archivedSearch.loadFromFile(path: path)
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
        self.search = nil
        self.state = .archived
        self.viewUpdate()
    }
}
// MARK: - SearchVC extensions
extension SearchVC: ModelDelegate {
    func getThumbnailsCompleted(_ thumbnails: [UIImage]) {}
    func getSearchCompleted(_ searchedItems: Search) {
        self.search = searchedItems
        viewUpdate()
        if self.state == .searchingCompleted || self.state == .selected || self.state == .archived {
            presentSearchResultVC(barTitle: self.searchBar.text ?? "", model: self.model)
        }
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
            self.model.getSearch(q: keyWords, maxResults: 15)
            break
        case .searchingCompleted:
            break
        case .selected:
            break
        }
        self.viewUpdate()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let item = self.searchBar.text, !item.isEmpty {
            if !self.archivedSearch.contains(item) {
                self.archivedSearch.append(item)
            }
            if self.search != nil {
                self.state = .searchingCompleted
                let keyWords: String = searchBar.text?.replacingOccurrences(of: " ", with: "+") ?? ""
                self.model.getSearch(q: keyWords, maxResults: 15, type: "video")
            }
        }
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.state == .archived {
            return self.archivedSearch.count
        } else {
            return self.search?.items.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.state == .archived {
            var reversedItems = self.archivedSearch
            reversedItems.reverse()
            let title = reversedItems[indexPath.row]
            let cell = self.tableView.dequeueReusableCell(withIdentifier: SearchTVC().identifier, for: indexPath) as! SearchTVC
            cell.setArchivedSearch(withTitle: title)
            return cell
        } else {
            let title = self.search?.items[indexPath.row].snippet.title
            let cell = self.tableView.dequeueReusableCell(withIdentifier: SearchTVC().identifier, for: indexPath) as! SearchTVC
            cell.setSearch(withTitle: title ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = self.tableView.cellForRow(at: indexPath) as! SearchTVC
        if let searchText = selectedCell.titleLabel.text {
            self.state = .selected
            self.searchBar.text = searchText
            let keyWords: String = searchText.replacingOccurrences(of: " ", with: "+")
            self.model.getSearch(q: keyWords, maxResults: 15, type: "video")
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var deleteAction: UIContextualAction {
            let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
                self.archivedSearch.reverse()
                self.archivedSearch.remove(at: indexPath.row)
                self.archivedSearch.reverse()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.viewUpdate()
                completion(true)
            }
            action.title = "Delete"
            action.backgroundColor = .red
            return action
        }
        if self.state == .archived {
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return nil
    }
}
