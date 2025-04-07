//
//  CharacterListConfigurator.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 07.04.2025.
//

import UIKit

final class CharacterListConfigurator {
    static func configure() -> UIViewController {
        
        let interactor = CharacterListInteractor(networkService: NetworkService())
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
