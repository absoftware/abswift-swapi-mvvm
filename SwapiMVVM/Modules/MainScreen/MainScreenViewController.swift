//
//  MainScreenViewController.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//
//  MVVM module
//  Template designed by Ariel Bogdziewicz.
//

import UIKit

class MainScreenViewController: UIViewController, MainScreenViewModelDelegate, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Subviews
    
    let refreshControl = UIRefreshControl()
    let tableView = UITableView(frame: .zero, style: .grouped)

    // MARK: - Dependencies
    
    var viewModel: MainScreenViewModel!

    // MARK: - Properties

    // Properties go here...

	// MARK: - UIViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View
        self.view.backgroundColor = .white

        // Table view
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.alwaysBounceVertical = true
        self.view.addSubview(self.tableView) { subview in
            subview.fill()
        }

        // Register cells
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CellId")

        // Refresh control
        self.refreshControl.addTarget(self, action: #selector(refreshed(_:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.reload()
    }

    // MARK: - MainScreenViewController methods (private methods of this controller)
    
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
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "CellId")
        
        // Take item
        let item = self.viewModel.items[indexPath.item]
        
        // Configure cell
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        cell.accessoryType = item.enabled ? .disclosureIndicator : .none
        cell.selectionStyle = item.enabled ? .gray : .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selected(index: indexPath.row)
    }

    // MARK: - MainScreenViewModelDelegate methods (notifications from view model)

    func viewModel(_ viewModel: MainScreenViewModel, isLoading: Bool) {
        if isLoading {
            self.refreshControl.beginRefreshing()
        } else {
            self.refreshControl.endRefreshing()
        }
    }
    
    func viewModelUpdated(_ viewModel: MainScreenViewModel) {
        self.tableView.reloadData()
    }

    // MARK: - Actions (from buttons and other UI controls)

    @objc func refreshed(_ refreshControl: UIRefreshControl) {
        // All user actions must go directly to view model.
        // They can be handled by view controller only when action
        // is related only to user interface. So option pull down to refresh
        // notifies here view model about the need of refreshing.
        self.viewModel.reload()
    }
}
