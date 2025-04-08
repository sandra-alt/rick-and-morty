//
//  CharacterListConfigurator.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 07.04.2025.
//

import UIKit

final class CharacterListConfigurator {
    static func configure() -> UIViewController {
        
        let interactor = CharacterListInteractor(networkService: NetworkService(), persistenceService: CharacterPersistenceService())
        let presenter = CharacterListPresenter()
        let router = CharacterListRouter()

        let viewController = CharacterListViewController(interactor: interactor, router: router)

        interactor.presenter = presenter
        presenter.viewController = viewController

        router.viewController = viewController
        router.dataStore = interactor as? CharacterListDataStore

        return viewController
    }
}

class CharacterDetailsConfigurator {
    static func configure(characterID: Int) -> CharacterDetailsViewController {
        let networkService = NetworkService()
        let persistenceService = CharacterPersistenceService()
        
        let interactor = CharacterDetailsInteractor(networkService: networkService, persistenceService: persistenceService, characterID: characterID)
        let presenter = CharacterDetailsPresenter()
        let router = CharacterDetailsRouter()
        
        let viewController = CharacterDetailsViewController(interactor: interactor, router: router)
        
        presenter.viewController = viewController
        interactor.presenter = presenter
        router.viewController = viewController
        router.dataStore = interactor
        
        return viewController
    }
}
