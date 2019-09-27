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
    
    enum ItemType {
        case people
        case planets
        case films
        case species
        case vehicles
        case starships
    }
    
    struct Item {
        var itemType: ItemType
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
    
    // MARK: - Actions
    
    func reload() {
        self.isLoading = true
        self.swapi.getRoot() { result in
            
            self.isLoading = false
            switch result {
            case .success(let response):
                
                // Get responce
                let data = response.data
                self.items = [
                    Item(
                        itemType: .people,
                        title: localizedString("People"),
                        subtitle: nil,
                        url: data.people,
                        enabled: true),
                    Item(
                        itemType: .planets,
                        title: localizedString("Planets"),
                        subtitle: localizedString("TODO"),
                        url: data.planets,
                        enabled: false),
                    Item(
                        itemType: .films,
                        title: localizedString("Films"),
                        subtitle: localizedString("TODO"),
                        url: data.films,
                        enabled: false),
                    Item(
                        itemType: .species,
                        title: localizedString("Species"),
                        subtitle: localizedString("TODO"),
                        url: data.species,
                        enabled: false),
                     Item(
                        itemType: .vehicles,
                        title: localizedString("Vehicles"),
                        subtitle: localizedString("TODO"),
                        url: data.vehicles,
                        enabled: false),
                     Item(
                        itemType: .starships,
                        title: localizedString("Starships"),
                        subtitle: localizedString("TODO"),
                        url: data.starships,
                        enabled: false)
                ]
                
                // Notify view
                self.delegate?.viewModelUpdated(self)
                
            case .failure(let apiError):
                
                // TODO: Implement alerts
                break
            }
        }
    }
}
