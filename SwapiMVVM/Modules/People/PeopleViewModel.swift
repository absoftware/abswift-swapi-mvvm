//
//  PeopleViewModel.swift
//  SwapiMVVM
//
//  Created by Ariel Bogdziewicz on 30/09/2019.
//  Copyright © 2019 Ariel Bogdziewicz. All rights reserved.
//
//  MVVM module
//  Template designed by Ariel Bogdziewicz.
//

import Foundation

protocol PeopleViewModelDelegate: class {
    func viewModel(_ viewModel: PeopleViewModel, isLoading: Bool)
    func viewModelUpdate(_ viewModel: PeopleViewModel)
}

class PeopleViewModel {
    
    // MARK: - Dependencies
    
    weak var delegate: PeopleViewModelDelegate?
    private let flowController: PeopleFlowController
    private let swapi: SwapiService
    private let originalUrl: String
    
    // MARK: - Properties
    
    private(set) var isLoading: Bool = false {
        didSet {
            self.delegate?.viewModel(self, isLoading: self.isLoading)
        }
    }
    
    private(set) var searchText: String = ""

    private(set) var items: [SwapiListItemPeople] = []
    
    // MARK: - Initializers
    
    init(flowController: PeopleFlowController, swapi: SwapiService, url: String) {
        self.flowController = flowController
        self.swapi = swapi
        self.originalUrl = url
    }
    
    // MARK: - Actions
    
    func searchIfNeeded(text: String) {
        if self.items.count == 0 || text != self.searchText {
            self.search(text: text)
        }
    }

    func search(text: String) {
        guard !self.isLoading else {
            return
        }
        
        self.isLoading = true
        self.searchText = text.trim
        self.swapi.getList(type: SwapiListItemPeople.self, url: self.originalUrl, search: self.searchText) { result in
            
            self.isLoading = false
            switch result {
            case .success(let apiResponse):
                // Remember list of items.
                self.items = apiResponse.data.results
                
                // Notify delegate.
                self.delegate?.viewModelUpdate(self)
                
            case .failure(let apiError):
                self.flowController.show(apiError: apiError)
            }
        }
    }
}
