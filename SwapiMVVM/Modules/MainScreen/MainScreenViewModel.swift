//
//  MainScreenViewModel.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 27/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//
//  MVVM module
//  Template designed by Ariel Bogdziewicz.
//

import Foundation

protocol MainScreenViewModelDelegate: class {
    func viewModel(_ viewModel: MainScreenViewModel, isLoading: Bool)
    func viewModelUpdated(_ viewModel: MainScreenViewModel)
}

class MainScreenViewModel {
    
    // MARK: - Types
    
    enum ItemIdentifier {
        case people
        case planets
        case films
        case species
        case vehicles
        case starships
    }
    
    struct Item {
        var identifier: ItemIdentifier
        var title: String
        var subtitle: String?
        var url: String
        var enabled: Bool
    }
    
    // MARK: - Dependencies
    
    weak var delegate: MainScreenViewModelDelegate?
    private let flowController: MainScreenFlowController
    private let swapi: SwapiService
    
    // MARK: - Properties exposed for view controller
    
    private(set) var isLoading: Bool = false {
        didSet {
            self.delegate?.viewModel(self, isLoading: self.isLoading)
        }
    }
    
    private(set) var items: [Item] = []
    
    // MARK: - Initializers
    
    init(flowController: MainScreenFlowController, swapi: SwapiService) {
        self.flowController = flowController
        self.swapi = swapi
    }
    
    // MARK: - Actions (from view controller)
    
    func selected(index: Int) {
        let item = self.items[index]
        switch item.identifier {
        case .people:
            self.flowController.showPeople(url: item.url)
        default:
            // TODO: Implement modules for other identifiers.
            break
        }
    }
    
    func reload() {
        guard !self.isLoading else {
            return
        }
        
        self.isLoading = true
        self.swapi.getRoot() { result in
            
            self.isLoading = false
            switch result {
            case .success(let response):
                
                // Get responce
                let data = response.data
                self.items = [
                    Item(
                        identifier: .people,
                        title: localizedString("People"),
                        subtitle: nil,
                        url: data.people,
                        enabled: true),
                    Item(
                        identifier: .planets,
                        title: localizedString("Planets"),
                        subtitle: localizedString("TODO"),
                        url: data.planets,
                        enabled: false),
                    Item(
                        identifier: .films,
                        title: localizedString("Films"),
                        subtitle: localizedString("TODO"),
                        url: data.films,
                        enabled: false),
                    Item(
                        identifier: .species,
                        title: localizedString("Species"),
                        subtitle: localizedString("TODO"),
                        url: data.species,
                        enabled: false),
                     Item(
                        identifier: .vehicles,
                        title: localizedString("Vehicles"),
                        subtitle: localizedString("TODO"),
                        url: data.vehicles,
                        enabled: false),
                     Item(
                        identifier: .starships,
                        title: localizedString("Starships"),
                        subtitle: localizedString("TODO"),
                        url: data.starships,
                        enabled: false)
                ]
                
                // Notify view
                self.delegate?.viewModelUpdated(self)

            case .failure(let apiError):
                self.flowController.show(apiError: apiError)

            }
        }
    }
}
