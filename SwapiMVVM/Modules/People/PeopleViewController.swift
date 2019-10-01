//
//  PeopleViewController.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 30/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//
//  MVVM module
//  Template designed by Ariel Bogdziewicz.
//

import UIKit

class PeopleViewController: UIViewController, PeopleViewModelDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: - Subviews

    let refreshControl = UIRefreshControl()
    let searchBar = UISearchBar()
    let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Dependencies
    
    var viewModel: PeopleViewModel!

    // MARK: - Properties

    var searchTimer: Timer?

	// MARK: - UIViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View
        self.view.backgroundColor = .white
        
        // Search bar
        self.searchBar.placeholder = localizedString("Search")
        self.searchBar.delegate = self
        self.searchBar.text = self.viewModel.searchText
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.returnKeyType = .search
        self.view.addSubview(self.searchBar) { subview in
            subview.topSafe()
            subview.left()
            subview.right()
        }

        // Table view
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.alwaysBounceVertical = true
        self.view.addSubview(self.tableView) { subview in
            subview.top(to: self.searchBar.bottomAnchor)
            subview.left()
            subview.right()
            subview.bottom()
        }

        // Register cells
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "PeopleCellId")

        // Refresh control
        self.refreshControl.addTarget(self, action: #selector(refreshed(_:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.searchIfNeeded(text: self.searchBar.text ?? "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - PeopleViewController methods
    
    // Custom methods here...
    
    // MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell.
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "PeopleCellId")
        
        // Take item
        let item = self.viewModel.items[indexPath.item]

        // Configure cell
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.gender.rawValue
        cell.selectionStyle = .none
        
        return cell
    }

    // MARK: - PeopleViewModelDelegate methods
    
    func viewModel(_ viewModel: PeopleViewModel, isLoading: Bool) {
        if isLoading {
            self.refreshControl.beginRefreshing()
        } else {
            self.refreshControl.endRefreshing()
        }
    }
    
    func viewModelUpdate(_ viewModel: PeopleViewModel) {
        self.tableView.reloadData()
    }

    // MARK: - Actions

    @objc func refreshed(_ refreshControl: UIRefreshControl) {
        // All user actions must go directly to view model.
        // They can be handled by view controller only when action
        // is related only to user interface. So option pull down to refresh
        // notifies here view model about the need of refreshing.
        self.viewModel.search(text: self.viewModel.searchText)
    }
    
    // MARK: - Search timer methods
    
    func invalidateSearchTimer() {
        self.searchTimer?.invalidate()
        self.searchTimer = nil
    }
    
    func recreateSearchTimer() {
        self.invalidateSearchTimer()
        self.searchTimer = Timer.scheduledTimer(
            withTimeInterval: 1.2,
            repeats: false,
            block: { timer in
                
                self.invalidateSearchTimer()
                self.viewModel.search(text: self.searchBar.text ?? "")
        })
    }
    
    // MARK: - UISearchBarDelegate methods
    
    /// Return NO to not become first responder.
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        // Udpate title for cancel button.
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle(localizedString("Cancel"), for: .normal)
        }

        // Show cancel button for editing.
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    /// Called when text starts editing.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }

    /// Return NO to not resign first responder.
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        // Hide cancel button when ended editing.
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    /// Called when text ends editing.
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }

    /// Called when text changes (including clear).
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trim.isEmpty {
            self.invalidateSearchTimer()
            self.viewModel.search(text: "")
        } else {
            self.recreateSearchTimer()
        }
    }

    /// Called before text changes.
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }

    /// Called when keyboard search button pressed.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.viewModel.search(text: searchBar.text ?? "")
    }

    /// Called when bookmark button pressed.
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }

    /// Called when cancel button pressed.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        self.invalidateSearchTimer()
        self.viewModel.search(text: "")
    }

    /// Called when search results button pressed.
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }

    /// Called when scope button index is changed.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}
